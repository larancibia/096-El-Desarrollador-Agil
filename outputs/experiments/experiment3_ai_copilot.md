Loaded cached credentials.
Error executing tool default_api:write_file: Tool "default_api:write_file" not found in registry. Tools must use the exact names that are registered. Did you mean one of: "read_file", "list_directory", "write_todos"?
Here is the RCT design formatted as YAML.

```yaml
experiment_name: "GitHub Copilot Impact on Developer Velocity and Quality"
hypothesis: "GitHub Copilot increases developer velocity by 35% without reducing code quality."

design:
  type: "Randomized Controlled Trial (RCT)"
  duration: "8 weeks"
  participants:
    total_count: 100
    groups:
      - name: "Experimental Group"
        size: 50
        tooling: "GitHub Copilot enabled"
      - name: "Control Group"
        size: 50
        tooling: "Standard environment (No AI coding assistants)"

metrics:
  velocity:
    - "Story points completed per sprint"
    - "Number of Pull Requests (PRs) merged"
    - "Cycle time (commit to deploy)"
  quality:
    - "Bug rate (defects found in QA/production)"
    - "Code complexity (Cyclomatic complexity)"
    - "Test coverage percentage"
    - "Code review rework rate (comments per PR)"
  learning:
    - "Time to proficiency in new frameworks/libraries"
    - "Documentation lookup frequency"
  satisfaction:
    - "Weekly developer satisfaction surveys (Likert scale)"
    - "Perceived cognitive load"

protocol:
  randomization_strategy:
    method: "Stratified Random Sampling"
    strata:
      - factor: "Experience Level"
        levels: ["Junior", "Mid-level", "Senior"]
      - factor: "Primary Language"
        levels: ["Python", "JavaScript/TypeScript", "Java", "Go"]
    procedure: "Participants are paired within strata and randomly assigned to Control or Experimental groups to ensure balanced skill distribution."

  quality_assurance:
    automated_analysis:
      - tool: "SonarQube"
        checks: ["Code Smells", "Security Hotspots", "Duplication"]
      - tool: "ESLint/Pylint"
        checks: ["Style adherence", "Potential errors"]
    manual_review:
      - "Peer code reviews required for all PRs"
      - "Reviews focus on logic, maintainability, and architectural fit"

  blinding:
    type: "Single-blind (Code Reviewers)"
    description: "Code reviewers will not be explicitly informed which group the PR author belongs to, although generated code patterns might be distinguishable. Authors are instructed not to mention Copilot usage in PR descriptions."

  statistical_analysis:
    primary_outcome: "Difference in mean velocity (Story Points) between groups."
    test_method: "Independent samples t-test (or Mann-Whitney U test if non-normal distribution)"
    significance_level: 0.05
    power_analysis: "Pre-study power analysis to confirm n=50 per group is sufficient for detecting 35% effect size."
    secondary_outcomes:
      - "Comparison of bug rates (Chi-square test)"
      - "Correlation between satisfaction and velocity"
```
