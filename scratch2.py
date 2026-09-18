import re

with open('lib/features/wizard/presentation/screens/step1_identity.dart', 'r') as f:
    lines = f.readlines()

new_lines = []
skip_until = -1
for i in range(len(lines)):
    if i < skip_until: continue
    
    if "late TextEditingController _apiKeyController;" in lines[i] or \
       "late TextEditingController _githubTokenController;" in lines[i]:
       continue
       
    if "_apiKeyController = TextEditingController" in lines[i] or \
       "_githubTokenController = TextEditingController" in lines[i]:
       continue
       
    if "_apiKeyController.dispose();" in lines[i] or \
       "_githubTokenController.dispose();" in lines[i]:
       continue

    if "// API Key Section" in lines[i]:
       skip_until = i + 149
       continue

    new_lines.append(lines[i])

with open('lib/features/wizard/presentation/screens/step1_identity.dart', 'w') as f:
    f.writelines(new_lines)

