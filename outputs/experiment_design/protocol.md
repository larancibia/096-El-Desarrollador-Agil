# Experimental Protocol

**Generated:** 2025-11-24 12:18

**Hypothesis:** Desarrolladores usando Pomodoro de 45 minutos muestran 30% más productividad medida en story points completados

---

```yaml
experiment_protocol:
  meta:
    title: "Effect of 45-Minute Time-Boxing on Developer Productivity"
    version: "1.0.0"
    author: "Gemini CLI Agent"
    last_updated: "2025-11-24"

  hypothesis:
    h0_null: "There is no statistically significant difference in normalized story point velocity between developers using a 45-minute work/break cycle and those using a standard 25-minute cycle."
    h1_alternative: "Developers utilizing a 45-minute work/break cycle demonstrate a statistically significant increase (specifically testing for +30%) in normalized story point velocity compared to the control group."

  experimental_design:
    type: "Randomized Controlled Trial (RCT) with Stratified Sampling"
    justification: "A between-subjects RCT minimizes carryover effects (e.g., cognitive fatigue or habit formation) that would complicate a crossover design. Stratification ensures balanced representation of seniority levels across groups."
    groups:
      group_A: "Experimental (Long Cycle: 45m work / 15m break)"
      group_B: "Control (Standard Cycle: 25m work / 5m break)"

  variables:
    independent:
      name: "Work Cycle Duration"
      type: "Categorical"
      levels:
        - "45 minutes work / 15 minutes break"
        - "25 minutes work / 5 minutes break"
    dependent:
      primary:
        name: "Normalized Velocity Change"
        description: "Percentage change in weekly completed Story Points relative to individual pre-experiment baseline."
        units: "Percentage (%)"
        measurement_method: "(Weekly_SP - Baseline_SP) / Baseline_SP"
      secondary:
        - name: "Focus Quality"
          units: "Likert Scale (1-10)"
          measurement_method: "Daily self-report survey"
        - name: "Interrupt Frequency"
          units: "Count/Day"
          measurement_method: "Self-logged tally"
    control:
      - "Role (Software Engineers only)"
      - "Project Phase (Exclude teams in critical crunch/release freeze)"
      - "Tooling (Both groups use the same timer application, configured differently)"
      - "Work Environment (Remote/Office mix distributed equally)"

  randomization:
    strategy: "Stratified Random Assignment"
    strata:
      - "Seniority (Junior, Mid, Senior)"
      - "Stack (Frontend, Backend, DevOps)"
    method: "Computer-generated random sequence within each stratum."

  data_collection:
    tools:
      - "Project Management API (Jira/Linear/Trello) for Story Points"
      - "Automated Timer Logger (Custom script or app export) for adherence"
      - "Daily Micro-Survey (Google Forms/Typeform)"
    schedule:
      baseline_phase: "Week -2 to Week 0 (Historical data extraction)"
      active_phase: "Week 1 to Week 6 (Daily logging + Weekly velocity export)"
      review_phase: "Week 7 (Data cleaning)"

  sample_size:
    n_total: 80
    n_per_group: 40
    power_analysis:
      alpha: 0.05
      power: 0.80
      effect_size_d: 0.63
      justification: "To detect a 30% improvement with moderate variance, N=40 per group provides sufficient power (>0.80) at α=0.05."

  statistical_analysis:
    primary_test: "Independent Samples t-test (one-tailed)"
    secondary_test: "Mann-Whitney U test (if normality assumption is violated)"
    data_handling:
      outliers: "Winsorize top/bottom 5% of velocity changes to handle sprint anomalies."
      missing_data: "Exclude participants with <75% protocol adherence (Per-Protocol Analysis)."

  threats_to_validity:
    internal:
      - "Adherence: Participants may not strictly follow the timer."
        - *Mitigation:* Use automated logger; require screen-time screenshot or active timer logs.
      - "Story Point Inflation: Teams might inflate points to look 'productive'."
        - *Mitigation:* Use 'Normalized Velocity' against their own history, assuming inflation rate is constant over 6 weeks.
    external:
      - "Task Complexity: 45m might suit backend deep work better than support tickets."
        - *Mitigation:* Stratification by role type.

  ethics:
    consent: "Written informed consent required."
    privacy: "Data pseudonymized. Individual performance data explicitly NOT shared with managers/HR."
    risk_mitigation: "Participants advised to revert to normal working patterns if experiencing excessive fatigue."

  timeline_execution:
    week_0: "Recruitment, Consent, Baseline Calculation, Group Assignment."
    week_1: "Onboarding & Tool Setup (Dry run)."
    week_2_5: "Core Experiment execution."
    week_6: "Final week & Post-experiment qualitative interview."
```