# Competitive Landscape

> Snapshot date: 2026-08-13. Revalidate quarterly.

# Part C — Competitive landscape and project position

## 8. 다시 검증한 선행 프로젝트

### Uno.Cupertino

강점:

- WinUI control을 alternative design system으로 재테마하는 구조 검증
- Button/TextBox/Toggle/Slider/Picker 등 기본 form controls coverage
- Apache-2.0
- cross-platform breadth

한계:

- 목적이 최신 macOS desktop 전체 복제가 아니라 cross-platform Cupertino theme
- 현재도 `Add Cupertino NavigationView` (#523), `Add Cupertino TreeView` (#524), `Add Cupertino TimePicker` (#471) 같은 **미구현 기능 요청 이슈가 open**
- open issue는 구현 약속이나 개발 중이라는 뜻이 아님

### Devolutions.AvaloniaTheme.MacOS

- Avalonia용 AppKit-like theme
- 2026년에도 활발히 배포
- 공식 설명이 `Work in Progress`
- Fluent theme을 미구현 control fallback/출발점으로 사용
- Avalonia 12 기반, pure WinUI가 아님

### Tahoe.Avalonia

2026년 4월 생성된 신생 project. 저장소 설명 자체가 **“Modern looking MacOS Tahoe inspired theme library for Avalonia UI.”**

현재 공개 tree에는 다음이 확인된다.

- `TahoeWindow`
- `EdgeHighlight`
- `SettingBox`
- `ExpandableSettingBox`
- Button / CheckBox / ComboBox / DataGrid / ListBox / Slider 등의 AXAML styles

하지만 현재 규모가 매우 작고 별도 repository license가 확인되지 않는다. **코드 복사 금지, visual/architecture observation만 허용**한다.

### SpanFinder / LumiFinder

- 순수 WinUI 3 / Windows App SDK에서 Finder의 Miller Columns, split view, Quick Look, keyboard-first workflow 등을 실제로 구현한 앱
- 기술 feasibility의 좋은 증거
- 그러나 재사용 디자인 시스템 package가 아니라 완성 앱

### 현재 포지션

```text
Uno            → cross-platform Cupertino
Devolutions    → Avalonia AppKit-like theme
Tahoe.Avalonia → early Tahoe/Avalonia experiment
SpanFinder     → macOS workflow를 구현한 WinUI app
Glassline.WinUI     → pure WinUI + current Apple-desktop-inspired full design system
```

**현재 검색 범위에서 마지막 조합을 성숙한 standalone library로 완성한 대표 프로젝트는 확인하지 못했다.** 이 문장은 “세상에 절대 없다”가 아니라 **2026-08-13 공개 landscape에서 확인하지 못했다**는 의미로 사용한다.

---
