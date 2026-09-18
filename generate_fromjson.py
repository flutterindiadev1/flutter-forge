import re

content = open("lib/features/wizard/models/project_config.dart").read()

classes = re.findall(r'class\s+(\w+)(?:\s+extends\s+\w+)?\s*{([^}]+const\s+\1\s*\({([^}]+)}\);)', content, re.MULTILINE | re.DOTALL)

for cls_name, cls_body, constructor_args in classes:
    print(f"  factory {cls_name}.fromJson(Map<String, dynamic> json) {{")
    print(f"    return {cls_name}(")
    
    # parse constructor args
    args = [a.strip() for a in constructor_args.split(',')]
    for arg in args:
        if not arg: continue
        # Handle 'this.prop = default' or 'required this.prop'
        m = re.search(r'this\.(\w+)', arg)
        if m:
            prop = m.group(1)
            # We don't have types here easily, but we can guess or just do json['prop']
            print(f"      {prop}: json['{prop}'],")
    print("    );")
    print("  }\n")
