# Contributing to GCP Data Engineering 360°

Thank you for your interest in contributing to this repository! This guide will help you get started.

## How to Contribute

### Reporting Issues

- Use GitHub Issues to report bugs or suggest features
- Include detailed steps to reproduce bugs
- For feature requests, explain the use case and expected behavior

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Test your changes**
   ```bash
   # Run Python tests
   pytest tests/
   
   # Check code style
   black --check .
   flake8 .
   ```
5. **Commit with clear messages**
   ```bash
   git commit -m "Add: description of your changes"
   ```
6. **Push and create PR**
   ```bash
   git push origin feature/your-feature-name
   ```

### Folder Structure Template

When adding a new module, follow this structure:

```
/module-name/
├── README.md              # 4W+H format documentation
├── /3d-interactive/
│   ├── index.html         # Three.js visualization
│   ├── main.js            # JavaScript code
│   └── styles.css         # Styling
├── /python-labs/
│   ├── 01-basics.ipynb    # Jupyter notebooks
│   ├── 02-advanced.ipynb
│   └── utils.py           # Helper functions
├── /sql-labs/
│   ├── 01-basic-queries.sql
│   ├── 02-advanced-queries.sql
│   └── README.md          # SQL documentation
├── /exercises/
│   ├── easy/
│   ├── medium/
│   ├── hard/
│   └── solutions/
├── /iac/
│   ├── main.tf            # Terraform configuration
│   ├── variables.tf
│   └── outputs.tf
└── /diagrams/
    ├── architecture.svg
    └── data-flow.png
```

### README.md Template (4W+H Format)

```markdown
# Module Name

## What
[2-3 paragraphs explaining the concept]

## Why
[Business value and use cases]

## When
[When to use this service/pattern]

## Who
[Target audience and roles]

## How
[Step-by-step implementation guide]

## Prerequisites
- GCP Project with billing enabled
- Required APIs enabled
- Necessary IAM permissions

## Quick Start
[Code snippets to get started]

## Interview Tips
[Common interview questions and answers]

## Teardown
[Cleanup scripts to avoid charges]
```

### 3D Visualization Standards

- Use Three.js for all 3D visualizations
- Follow the cyberpunk aesthetic (dark mode, neon colors)
- Include:
  - Rotatable/zoomable camera controls
  - Hover tooltips with metrics
  - Click-to-explode components
  - Particle animations for data flow
- Test on Chrome, Firefox, and Safari

### Code Style

- **Python**: Follow PEP 8, use Black formatter
- **JavaScript**: Use ES6+, consistent indentation
- **SQL**: Use uppercase keywords, proper indentation
- **Terraform**: Follow HashiCorp style guide

### Testing

- Add unit tests for Python code
- Test notebooks can be executed end-to-end
- Verify SQL queries work on BigQuery
- Test 3D visualizations in multiple browsers

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help newcomers learn
- Focus on the technical merit of contributions

## Questions?

- Open a GitHub Issue
- Join our Discord community
- Check existing documentation

Thank you for contributing!
