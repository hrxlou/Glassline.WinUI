# Repository & Engineering Workflow


# Part G — Repository and engineering workflow

## 22. Repository structure

```text
Glassline.WinUI/
├─ .github/
│  ├─ workflows/
│  ├─ ISSUE_TEMPLATE/
│  └─ pull_request_template.md
├─ docs/
│  ├─ architecture/
│  ├─ design-system/
│  ├─ legal/
│  └─ releases/
├─ research/
│  ├─ AppleReferenceLab/
│  ├─ corpus-index/
│  ├─ measurements/
│  └─ decisions/
├─ .local-research/           # gitignored local-only reference material
├─ src/
│  ├─ Glassline.WinUI.Theme/
│  ├─ Glassline.WinUI.Controls/
│  └─ Glassline.WinUI.Effects/
├─ samples/
│  └─ Glassline.Gallery/
├─ tests/
├─ eng/
│  ├─ Directory.Packages.props
│  ├─ versioning/
│  └─ scripts/
├─ LICENSE
├─ THIRD-PARTY-NOTICES
├─ SECURITY.md
├─ CONTRIBUTING.md
└─ CHANGELOG.md
```

---

## 23. Work-item taxonomy

GitHub labels 예시:

```text
area:foundation
area:glass
area:control
area:shell
area:a11y
area:input
area:perf
area:legal
area:docs

priority:p0
priority:p1
priority:p2

state:research
state:ready
state:implementing
state:review
state:blocked

risk:visual
risk:platform
risk:ip
```

모든 P0 issue에는 DoR/DoD checklist와 reference IDs를 붙인다.

---

## 24. Branch / release policy

- `main` 항상 buildable
- feature branch → PR
- visual change PR은 before/after Gallery screenshot 필수
- public token/style key change는 API review 필요
- `preview` NuGet feed에서 먼저 dogfood
- stable은 milestone gate 통과 후만 publish

### Release channels

```text
0.x-preview → API/visual 변화 허용
1.0        → P0 + shell + legal gate
1.x        → additive controls + pinned design generation
2.0        → breaking public API/default design generation change
```

---
