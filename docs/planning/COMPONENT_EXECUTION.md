# Component Execution Plan


# Part E — Component execution plan

## 14. Component priority

### P0 — usable desktop system

- Button variants
- TextBox / PasswordBox
- ToggleSwitch
- Slider
- CheckBox / RadioButton
- ComboBox / DropDownButton
- SegmentedControl
- SearchField
- Sidebar / navigation row
- ListView row
- Toolbar / toolbar groups
- MenuFlyout / ContextMenu
- custom window shell
- Settings group / row primitives

### P1 — desktop completeness

- TreeView
- OutlineView
- sortable/resizable Table
- SplitView / Inspector
- TabView
- Popover
- Sheet / Alert
- Date / Time picker
- Stepper / Number field
- ColorWell / ColorPicker mapping

### P2 — polish

- toolbar customization
- detachable panel/popover patterns
- command palette
- advanced morphing
- refined drag/drop
- advanced optical refraction

---

## 15. Definition of Ready

component issue는 다음이 없으면 개발 시작하지 않는다.

- [ ] Apple official/reference scene 2개 이상
- [ ] Light + Dark reference
- [ ] 주요 interaction state reference
- [ ] WinUI base control 또는 composite mapping 결정
- [ ] keyboard semantics 정의
- [ ] Automation role/name/value 정의
- [ ] High Contrast fallback 정의
- [ ] token dependencies 확인
- [ ] 외부 asset/code provenance 확인
- [ ] baseline screenshot test case 설계

---

## 16. Definition of Done

모든 component는 최소 다음을 통과한다.

- [ ] Normal
- [ ] PointerOver
- [ ] Pressed
- [ ] KeyboardFocused
- [ ] Disabled
- [ ] Selected/Checked 등 semantic state
- [ ] Light
- [ ] Dark
- [ ] Active / Inactive window
- [ ] High Contrast / Solid fallback
- [ ] 125 / 150 / 200% scale
- [ ] text scaling
- [ ] long localized string
- [ ] RTL smoke test
- [ ] Narrator / UIA role-name-state-value
- [ ] Korean/Japanese/Chinese IME if text input
- [ ] visual regression baseline
- [ ] no unlicensed asset
- [ ] Gallery sample
- [ ] API docs if public

---

## 17. Suggested milestone plan

아래 기간은 **1명 full-time engineer equivalent의 rough estimate**이며, visual design/research 인력이 별도면 단축 가능하다.

### M0 — Corpus & decisions · 1–2주

- repository/bootstrap
- AppleReferenceLab
- 50+ scene index
- measurement ledger
- ADR 0001–0009
- brand/package name

**Exit:** Button/Toggle/Slider/Sidebar/Toolbar/Popover 규칙을 source와 함께 설명 가능.

### M1 — Foundation · 1주

- theme dictionaries
- semantic color
- typography
- spacing/radius
- active/inactive
- Solid fallback

### M2 — Glass Engine · 2–3주

- SidebarGlass
- ToolbarGlass
- PopoverGlass
- InteractiveGlass
- pointer specular
- pressed/release motion
- scroll-edge
- auto fallback

**Go/No-Go:** benchmark scene에서 안정적인 품질과 성능이 나오지 않으면 advanced lensing을 버리고 simpler adaptive material로 v1 고정.

### M3 — Core Controls · 3–4주

Button → Toggle → Slider → TextBox → Search → Check/Radio → Combo → Segmented.

### M4 — Window & Shell · 2–3주

- titlebar integration
- right caption policy
- sidebar + toolbar
- Settings archetype
- Finder/productivity archetype
- Snap / system menu / resize verification

### M5 — Desktop Data / Presentation · 4–6주

List / Tree / Outline / Table / Menu / Popover / Sheet / Inspector.

### M6 — Hardening / Release Candidate · 2–3주

- visual regression
- UIA
- keyboard / IME
- performance
- package validation
- IP gate
- docs + Gallery

---
