# Product Contract


## 0. 이 문서가 해결하는 것

이전 문서는 visual research와 prototype 방향은 충분했지만 실제 개발 진행을 위해 다음이 부족했다.

- 지원 OS / Windows App SDK 기준선
- NuGet 패키지 경계와 허용 의존성
- C# / C++ 소비자 지원 정책
- public API / visual-breaking-change 버전 정책
- 연도별 Apple 디자인 변화에 대한 **Design Generation** 정책
- component별 Definition of Ready / Definition of Done
- CI, screenshot baseline, UI Automation, IME, DPI, GPU fallback 검증 방식
- 성능 예산과 benchmark scene
- Apple 자산·폰트·아이콘·스크린샷·타 프로젝트 코드의 provenance 규칙
- 공개 배포 전 법무/IP release gate
- 경쟁 프로젝트가 발전했을 때의 재검증 기준
- 프로젝트를 계속할지 축소/피벗할지 판단하는 kill criteria

v5는 위 항목을 추가해 **개발팀이 이 문서만 보고 저장소를 만들고 작업을 쪼개고 release 여부를 판단할 수 있는 상태**를 목표로 한다.

---

# Part A — Product contract

## 1. 제품 정의

**Glassline.WinUI는 UI framework가 아니다.** WinUI 3의 native control behavior를 유지한 채 visual system과 desktop shell primitives를 대체하는 디자인 시스템이다.

```text
Windows application
   ↓
Microsoft.UI.Xaml / WinUI 3 controls
   ↓
Glassline.WinUI
   ├─ semantic tokens
   ├─ ResourceDictionary / ControlTemplate
   ├─ VisualState / Composition interaction
   ├─ window & desktop shell primitives
   └─ optional advanced optical effects
   ↓
Windows App SDK
   ↓
Windows 11
```

### 핵심 원칙

**Native behavior, alternate visual system.**

가능하면 다음 실제 WinUI control을 유지한다.

- `Button`, `ToggleButton`
- `TextBox`, `PasswordBox`, `AutoSuggestBox`
- `ToggleSwitch`, `Slider`
- `CheckBox`, `RadioButton`
- `ComboBox`, `DropDownButton`
- `ListView`, `ItemsView`, `TreeView`
- `MenuFlyout`, `Flyout`, `ContentDialog`
- `NavigationView`, `SplitView`, `TabView`

새 custom control은 **WinUI에 대응되는 semantics가 없거나 composite behavior가 필요한 경우에만** 만든다.

---

## 2. v1 범위와 비범위

### v1 Full-fidelity target

- **Windows 11**
- x64 + ARM64
- WinUI 3 / Windows App SDK
- C# WinUI app first-class
- Light / Dark / High Contrast
- keyboard / mouse / precision touchpad / touch
- Korean / Japanese / Simplified Chinese IME smoke tests
- 100 / 125 / 150 / 200% scale
- active / inactive window
- transparency/effect fallback

### v1 비범위

- Windows 10의 동일 visual fidelity 보장
- iOS / macOS / Linux / Android / Web
- SwiftUI API compatibility
- SF Pro 또는 SF Symbols 재배포
- Apple 앱 화면의 pixel-identical clone
- 자체 XAML renderer / Skia renderer
- UIKit/AppKit binary compatibility
- 모든 Apple animation을 1:1 reverse engineering

### 권장 플랫폼 기준선

2026-08-13 기준 Microsoft의 공식 Windows App SDK 릴리스에는 **2.3.1 stable**이 존재한다. 프로젝트 생성 시 현재 stable 버전을 중앙에서 pin하고, preview/experimental은 production package에서 사용하지 않는다.

정책:

```text
main branch       → current stable WinAppSDK
compat CI         → 필요 시 직전 stable line
experimental lab → preview/experimental API 허용, shipping package에는 금지
```

**링크:** https://github.com/microsoft/WindowsAppSDK/releases

---

## 3. Windows와 Apple 문법을 어디서 나눌 것인가

### Apple-inspired로 바꾸는 것

- window silhouette / radius / shadow
- titlebar-content integration
- edge-to-edge sidebar composition
- toolbar grouping / glass islands
- content density / spacing hierarchy
- semantic surface hierarchy
- interactive glass response
- selection / list / settings group treatment
- popover / inspector / sheet visual grammar
- custom icon optical language

### Windows 관례를 유지하는 것

- caption cluster 위치: **오른쪽 상단**
- 순서: **Minimize → Maximize/Restore → Close**
- 기본 glyph 의미: `− / □ / ×`
- Alt+F4
- double-click titlebar maximize/restore
- Snap / resize / system menu
- Windows keyboard conventions
- Windows UI Automation / Narrator
- native text selection / clipboard / IME

### Caption 구현 원칙

WinUI는 content를 titlebar 영역까지 확장하면서도 system caption controls를 유지할 수 있다. v1 기본 구현은 이를 우선한다. 완전 custom caption glyph는 **같은 오른쪽 위치와 Windows semantics를 유지할 수 있을 때만** 별도 opt-in으로 검토한다.

Microsoft reference: https://learn.microsoft.com/en-us/windows/apps/develop/title-bar?tabs=winui3

---
