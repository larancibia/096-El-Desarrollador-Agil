# El Desarrollador Ágil

**Author:** Luis Arancibia
**Topic:** Productivity
**Target:** 280 pages

## Project Structure

```
├── manuscript.md              # Main manuscript
├── book_config.yaml          # Configuration
├── outputs/                  # Generated reports
│   ├── research/             # Literature synthesis
│   ├── experiment_design/    # Experimental protocols
│   ├── data_analysis/        # Statistical results
│   └── figures/              # Charts and graphs
├── experiments/              # Experiment tracking
├── data/                     # Raw data
└── references/               # Bibliography
```

## Workflow

1. **Research:** Find scientific evidence
   ```bash
   python ../create_scientific_book.py research --query "your topic"
   ```

2. **Design Experiments:** Create rigorous protocols
   ```bash
   python ../create_scientific_book.py design-experiment --hypothesis "your claim"
   ```

3. **Run Experiments:** (Do this yourself)

4. **Analyze Data:** Generate statistical results
   ```bash
   python ../create_scientific_book.py analyze-data --data data/results.csv
   ```

5. **Write Chapters:** Evidence-based writing
   ```bash
   python ../create_scientific_book.py write-chapter --chapter 4
   ```

6. **Validate:** Check logical rigor
   ```bash
   python ../create_scientific_book.py validate
   ```

7. **Humanize:** Make it engaging
   ```bash
   python ../create_scientific_book.py humanize
   ```

8. **Export:** Generate final PDF
   ```bash
   python ../create_scientific_book.py export --format pdf
   ```

## Status

- [ ] Research phase
- [ ] Experiments designed
- [ ] Data collected
- [ ] Data analyzed
- [ ] Chapters written
- [ ] Arguments validated
- [ ] Narrative polished
- [ ] Final export

## Notes

[Your project notes]
