import re

with open('lib/features/wizard/presentation/cubit/wizard_cubit.dart', 'r') as f:
    lines = f.readlines()

def should_skip(i):
    # Remove google_generative_ai import
    if "import 'package:google_generative_ai/google_generative_ai.dart';" in lines[i]: return True
    # Remove loadSavedApiKey call
    if "loadSavedApiKey();" in lines[i]: return True
    # Remove triggerBackgroundAnalysis call
    if "triggerBackgroundAnalysis();" in lines[i]: return True
    # Remove geminiApiKey assignment
    if "geminiApiKey: local.geminiApiKey," in lines[i]: return True
    # Remove githubToken assignment
    if "githubToken: local.githubToken," in lines[i]: return True
    return False

new_lines = []
skip_until = -1
for i in range(len(lines)):
    if i < skip_until: continue
    
    if should_skip(i): continue
    
    # aiAnalysisStatus: AiAnalysisStatus.idle
    if "aiAnalysisStatus: existingConfig.features.isNotEmpty" in lines[i]:
        new_lines.append("        aiAnalysisStatus: AiAnalysisStatus.idle,\n")
        skip_until = i + 3
        continue
        
    # Remove API Key Management
    if "// ─── API Key Management" in lines[i]:
        skip_until = i + 72
        continue
        
    # Remove Background AI Analysis
    if "// ─── Background AI Analysis" in lines[i]:
        skip_until = i + 202
        continue
        
    # Remove LlmInstruction
    if "void addLlmInstruction" in lines[i]:
        skip_until = i + 21
        continue
        
    # Remove GitHub token check in submitProject
    if "if (!state.githubTokenSaved &&" in lines[i]:
        skip_until = i + 11
        continue
        
    # Remove llmInstructions in SP ProjectConfig
    if "llmInstructions: local.llmInstructions" in lines[i]:
        skip_until = i + 9
        continue
        
    # Remove analyzeRequirements
    if "Future<({List<String> questions, List<String> features})> analyzeRequirements" in lines[i]:
        skip_until = len(lines) - 1 # Ends at the end of class
        continue

    new_lines.append(lines[i])

with open('lib/features/wizard/presentation/cubit/wizard_cubit.dart', 'w') as f:
    f.writelines(new_lines)

