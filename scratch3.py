import re

with open('lib/features/wizard/presentation/screens/step2_features.dart', 'r') as f:
    lines = f.readlines()

new_lines = []
skip_until = -1
for i in range(len(lines)):
    if i < skip_until: continue
    
    # Remove AI Analysis error block
    if "// AI Analysis error warning" in lines[i]:
        skip_until = i + 34
        continue

    # Remove aiAnalysisStatus == AiAnalysisStatus.running checks in Graph View
    if "child: state.aiAnalysisStatus == AiAnalysisStatus.running" in lines[i]:
        # Just use the else part
        new_lines.append("                          child: FeatureDependencyGraph(\n")
        new_lines.append("                              nodes: state.config.features,\n")
        new_lines.append("                              selectedNodeId: _selectedFeatureId,\n")
        new_lines.append("                              onNodeTap: (id) =>\n")
        new_lines.append("                                  setState(() => _selectedFeatureId = id),\n")
        new_lines.append("                              onNodeDragged: (id, x, y) =>\n")
        new_lines.append("                                  context.read<WizardCubit>().updateFeaturePosition(id, x, y),\n")
        new_lines.append("                            ),\n")
        skip_until = i + 20
        continue
        
    # Remove aiAnalysisStatus == AiAnalysisStatus.running in List View
    if "if (state.aiAnalysisStatus == AiAnalysisStatus.running)" in lines[i]:
        new_lines.append("                      if (state.config.features.isEmpty)\n")
        skip_until = i + 16
        continue
        
    # Remove LLM instructions section
    if "LLM Specific Instructions" in lines[i]:
        # Search backwards for the start of the section header to remove the Gap and SectionHeader
        # Actually just skip forward, we'll leave a couple Gaps, it's fine.
        skip_until = i + 172
        continue

    # Wait, there's another occurrence of LLM Specific Instructions that we need to be careful of?
    # Let me make sure I'm skipping the right amount.
    
    new_lines.append(lines[i])

with open('lib/features/wizard/presentation/screens/step2_features.dart', 'w') as f:
    f.writelines(new_lines)

