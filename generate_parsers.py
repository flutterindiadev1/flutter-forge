import re

content = open("lib/features/wizard/models/project_config.dart").read()

enums = re.findall(r'enum\s+(\w+)\s*{([^}]+)}', content)
enum_names = {e[0]: [x.strip() for x in e[1].split(',')] for e in enums}

classes = re.findall(r'class\s+(\w+)(?:\s+extends\s+\w+)?\s*{([^}]+const\s+\1\s*\({([^}]+)}\);)', content, re.MULTILINE | re.DOTALL)
class_names = [c[0] for c in classes]

out = "import 'project_config.dart';\nimport 'feature_node.dart';\n\n"

for cls_name, cls_body, constructor_args in classes:
    out += f"{cls_name} parse{cls_name}(Map<String, dynamic> json) {{\n"
    out += f"  return {cls_name}(\n"
    
    args = [a.strip() for a in constructor_args.split(',')]
    for arg in args:
        if not arg: continue
        m = re.search(r'(?:required\s+)?this\.(\w+)', arg)
        if m:
            prop = m.group(1)
            # Find the type of this prop in cls_body
            type_match = re.search(fr'final\s+(.*?)\s+{prop};', cls_body)
            if type_match:
                ptype = type_match.group(1).strip()
                is_nullable = ptype.endswith('?')
                base_type = ptype.replace('?', '')
                
                getter = f"json['{prop}']"
                
                if base_type == 'String':
                    val = f"{getter} as String?" if is_nullable else f"{getter} as String? ?? ''"
                elif base_type == 'int':
                    val = f"{getter} as int?" if is_nullable else f"{getter} as int? ?? 0"
                elif base_type == 'double':
                    val = f"{getter} as double?" if is_nullable else f"{getter} as double? ?? 0.0"
                elif base_type == 'bool':
                    val = f"{getter} as bool?" if is_nullable else f"{getter} as bool? ?? false"
                elif base_type == 'List<String>':
                    val = f"({getter} as List?)?.map((e) => e as String).toList() ?? []"
                elif base_type.startswith('List<'):
                    inner_type = base_type[5:-1]
                    if inner_type in class_names:
                        val = f"({getter} as List?)?.map((e) => parse{inner_type}(e as Map<String, dynamic>)).toList() ?? []"
                    else:
                        val = f"({getter} as List?)?.map((e) => e as {inner_type}).toList() ?? []"
                elif base_type in enum_names:
                    val = f"{base_type}.values.firstWhere((e) => e.name == {getter}, orElse: () => {base_type}.values.first)"
                elif base_type in class_names:
                    if is_nullable:
                        val = f"{getter} != null ? parse{base_type}({getter} as Map<String, dynamic>) : null"
                    else:
                        val = f"{getter} != null ? parse{base_type}({getter} as Map<String, dynamic>) : const {base_type}()"
                elif base_type == 'FeatureNode':
                     val = f"FeatureNode.fromJson({getter})"
                elif base_type == 'List<FeatureNode>':
                     val = f"({getter} as List?)?.map((e) => FeatureNode.fromJson(e)).toList() ?? []"
                else:
                    val = getter
                    
                out += f"    {prop}: {val},\n"
    out += "  );\n}\n\n"

open("lib/features/wizard/models/project_config_parsers.dart", "w").write(out)
