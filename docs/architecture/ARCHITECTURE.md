# Architecture & Package Contract


# Part D — Architecture and package contract

## 9. Package layout

### `Glassline.WinUI.Theme`

목적: 가능한 한 **pure XAML**.

- ThemeResource
- ResourceDictionary
- Style
- ControlTemplate
- VisualState
- semantic tokens
- light/dark/high-contrast dictionaries

**지원:** C# WinUI / C++/WinRT WinUI 모두 최대한 사용 가능하게 유지.

### `Glassline.WinUI.Controls`

목적: WinUI 기본 control로 표현하기 어려운 composite behavior.

- `GlasslineSearchField`
- `GlasslineSegmentedControl`
- `GlasslineOutlineView`
- `GlasslineInspector`
- toolbar helpers
- window shell helpers

**v1 소비자:** C# first-class.  
C++/WinRT에서 managed custom control을 직접 소비하는 문제를 Theme package와 분리한다.

### `Glassline.WinUI.Effects`

- advanced Composition helpers
- optional Win2D/D2D/D3D work
- feature detection
- adaptive fallback

Theme/Controls가 Effects를 강제 의존하지 않도록 한다.

### `Glassline.Gallery`

제품 품질의 핵심 test vehicle.

- Settings archetype
- Finder/productivity archetype
- component state matrix
- accessibility playground
- benchmark scenes

---

## 10. Dependency rules

### Allowed in Theme

- Windows App SDK / WinUI 3

### Allowed in Controls

- Theme
- Windows App SDK
- .NET BCL

### Allowed in Effects

- Windows App SDK
- 명시적으로 승인한 rendering dependency

### 금지

- Uno
- Avalonia
- WPF
- Flutter/Chromium renderer
- Apple binary/design assets
- 임의의 third-party UI toolkit

외부 dependency를 추가하려면 ADR + license review가 필요하다.

---

## 11. Public API policy

### 기본 사용법

```xml
<Application.Resources>
    <glassline:GlasslineResources
        UseImplicitStyles="True"
        MaterialMode="Auto"
        DesignGeneration="2026" />
</Application.Resources>
```

```xml
<Button Content="Save" />
<TextBox PlaceholderText="Search" />
<ToggleSwitch IsOn="True" />
<Slider Value="0.6" />
```

일반 WinUI control을 그대로 쓰는 것이 기본이다.

추가 의미가 필요한 경우만 explicit style/attached property.

```xml
<Button Style="{StaticResource GlasslineGlassProminentButtonStyle}"
        Content="Apply" />

<CommandBar glassline:Glass.Group="PrimaryToolbar" />
```

### API design rules

- token 이름은 visual literal이 아니라 semantic role
- public API에 `macOS`, `SwiftUI`, `Aqua`, `Finder`를 넣지 않음
- internal source comment에는 reference provenance를 기록 가능
- style key는 stable contract로 취급
- internal template part name은 명시적으로 document하지 않으면 private

---

## 12. Design Generation / SemVer

Apple은 매년 디자인을 바꿀 수 있지만 consumer app이 package update 한 번으로 갑자기 전부 바뀌면 안 된다.

따라서 API version과 visual generation을 분리한다.

```text
Package version: 1.4.2
DesignGeneration: 2026
```

### 권장 정책

- **Patch**: 명백한 bug, a11y, performance fix. 의도적인 geometry 변화 금지.
- **Minor**: additive controls/tokens, opt-in 새로운 visual generation 허용.
- **Major**: API breaking change 또는 default generation 변경.

새 Apple 디자인을 연구해도 기존 generation baseline은 유지한다.

```xml
<glassline:GlasslineResources DesignGeneration="2026" />
```

나중에:

```xml
<glassline:GlasslineResources DesignGeneration="2027" />
```

처럼 병존할 수 있게 설계한다. 실제 public naming은 launch 전 branding review를 거친다.

---

## 13. Architecture Decision Records

최소 ADR:

- `ADR-0001` Pure WinUI 3, no cross-platform runtime
- `ADR-0002` Right-side Windows caption semantics
- `ADR-0003` Semantic token model
- `ADR-0004` Functional glass vs content surface separation
- `ADR-0005` No Apple assets in shipping package
- `ADR-0006` Theme package is cross-language; Controls C# first-class
- `ADR-0007` Full-fidelity target is Windows 11
- `ADR-0008` Design Generation separate from package SemVer
- `ADR-0009` Advanced refraction is optional, never release blocker

모든 큰 변경은 ADR로 남긴다.

---
