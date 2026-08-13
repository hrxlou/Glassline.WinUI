# Research Method & Measurement Ledger


## 4. 리서치 근거 우선순위

### Tier A — Apple 공식

- Human Interface Guidelines
- Apple Design Resources: macOS 26 / macOS 27 UI Kit
- SwiftUI / AppKit documentation
- WWDC25 / WWDC26 design sessions
- macOS release notes

Apple은 현재 macOS 27 UI Kit도 공식 Design Resources에서 제공한다.

**Reference:** https://developer.apple.com/design/resources/

### Tier B — 실제 macOS 화면 corpus

주요 corpus:

- 512 Pixels — macOS 26 Tahoe Screenshot Library
- 실제 macOS 26/27 machine capture

512 Pixels는 Appearance, System Settings, Finder, Control Center, Spotlight, Apple 앱 등의 실제 화면을 한 릴리스에서 폭넓게 비교하는 데 사용한다.

**Reference:** https://512pixels.net/projects/aqua-screenshot-library/macos-26-tahoe/

### Tier C — AppleReferenceLab

우리 소유의 macOS probe app을 만든다.

```text
research/AppleReferenceLab
  ├─ Buttons
  ├─ ToggleSlider
  ├─ TextInput
  ├─ Pickers
  ├─ Sidebar
  ├─ Toolbar
  ├─ MenuPopover
  ├─ Window
  └─ AccessibilityStates
```

표준 SwiftUI/AppKit control을 최소 modifier로 띄워 다음 상태를 직접 캡처한다.

- Light / Dark
- Active / Inactive
- Normal / Hover / Pressed / Focused / Disabled / Selected
- mini / small / regular / large control size
- accent variants
- transparency/contrast accessibility settings
- resize / scrolling / open-close transition

---

## 5. Measurement Ledger

감으로 수치를 정하지 않는다. 모든 visual decision은 ledger에 근거를 남긴다.

권장 schema:

```csv
source_id,source_type,os_version,app,scene,component,state,appearance,
width,height,radius,padding_x,padding_y,gap,font_role,
material_role,selection_role,motion_note,confidence,asset_policy,notes
```

### 측정값 분류

- **Observed**: 실제 screenshot/reference에서 관찰한 값
- **Inferred**: 여러 화면을 비교해 추론한 값
- **Glassline decision**: Windows 맥락에 맞게 의도적으로 바꾼 값

배포되는 token 파일에는 `Observed Apple value` 자체를 마케팅하지 않는다. 최종 값은 **Glassline decision**으로 관리한다.

---
