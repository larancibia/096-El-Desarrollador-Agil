Loaded cached credentials.
Attempt 1 failed: You have exhausted your capacity on this model. Your quota will reset after 2s.. Retrying after 2431.8691609999996ms...
Error executing tool default_api:write_file: Tool "default_api:write_file" not found in registry. Tools must use the exact names that are registered. Did you mean one of: "read_file", "list_directory", "write_todos"?
Attempt 1 failed: You have exhausted your capacity on this model. Your quota will reset after 1s.. Retrying after 1832.412284ms...
Attempt 2 failed: You have exhausted your capacity on this model. Your quota will reset after 5s.. Retrying after 5832.640636ms...
```yaml
experiment_protocol:
  meta:
    title: "Quantifying the Cost of Context Switching on Developer Productivity"
    version: "1.0.0"
    author: "Gemini CLI Agent"
    last_updated: "2025-11-24"

  hypothesis:
    primary: "Each context switch event reduces developer productivity by an average of 23 minutes due to cognitive re-orientation costs."
    null: "There is no significant correlation between the frequency of context switches and daily productivity metrics or recovery time."

  experimental_design:
    type: "Observational Longitudinal Cohort Study"
    justification: "Naturalistic observation is required to capture genuine interruption patterns (Slack, meetings, urgent bugs) without the artificiality of a laboratory setting. Automated tracking removes self-reporting bias."
    setting: "Remote and Hybrid software development environments"

  participants:
    n_total: 100
    profile: "Professional Software Developers"
    selection_criteria:
      - "Full-time employment"
      - "Active contributor to a version-controlled codebase"
      - "Voluntary enrollment with consent for automated telemetry"

  duration: "4 weeks"

  variables:
    independent:
      name: "Context Switch Frequency"
      definition: "Count of events where focus shifts from 'Deep Work' apps (IDE, Terminal) to 'Communication' apps (Slack, Email, Calendar) for > 2 minutes."
    dependent:
      - name: "Recovery Time (Resumption Lag)"
        units: "Minutes"
        definition: "Time elapsed between the end of an interruption event and the resumption of sustained coding activity (active typing/editing > 5 minutes)."
      - name: "Productivity Proxy"
        units: "Normalized Volume"
        definition: "Composite score of Git commits, Lines of Code (LoC) changed, and Pull Requests merged, normalized against the individual's historical baseline."
    control:
      - "Developer Seniority (Junior/Mid/Senior)"
      - "Role (Frontend/Backend/DevOps)"
      - "Time of Day (Morning/Afternoon)"
      - "Day of Week"

  data_collection:
    method: "Automated Passive Telemetry"
    tools:
      - name: "RescueTime / WakaTime"
        purpose: "Granular tracking of active window/application focus and duration."
      - name: "Calendar API (Google/Outlook)"
        purpose: "Identification of scheduled interruptions (meetings) vs. unscheduled interruptions."
      - name: "Git / VCS Metadata"
        purpose: "Timestamped record of work output (commits) to correlate with focus blocks."
    data_points:
      - "Timestamp of focus switch"
      - "Duration of interruption"
      - "Category of interrupting application"
      - "Time until next code commit"

  statistical_analysis:
    primary_method: "Linear Mixed-Effects Models (LMM)"
    purpose: "To account for repeated measures within individuals while analyzing the fixed effect of context switches on productivity."
    secondary_analyses:
      - method: "Time-Series Cross-Correlation"
        purpose: "To determine the temporal lag (recovery time) between interruption end and activity resumption."
      - method: "Descriptive Statistics"
        purpose: "Calculate mean and median recovery times to test the '23 minutes' specific claim."

  threats_to_validity:
    internal:
      - "Hawthorne Effect: Participants may alter behavior because they know they are being tracked."
        - *Mitigation:* 4-week duration allows for habituation; discard Week 1 data if anomaly detected.
      - "Definition of 'Productivity': Code volume does not equal code quality."
        - *Mitigation:* Use 'Recovery Time' as a more objective cognitive metric independent of code quality.
    external:
      - "Tool Specificity: Results may depend on the specific stack or tools used."
        - *Mitigation:* diverse participant pool across different languages/stacks.

  ethics:
    privacy: "All telemetry data is hashed and anonymized at the client side where possible. No content (message text, code snippets) is recorded, only metadata (app name, timestamp, duration)."
    consent: "Explicit opt-in required. Participants can pause tracking at any time."
    reporting: "Aggregated results only; no individual performance reports generated."
```
