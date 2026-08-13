# Design System Specification


## 6. Semantic color / typography / icon system

### Color

RGB를 그대로 복사하기보다 역할을 매핑한다.

| Glassline token | 의미 |
|---|---|
| `Text.Primary` | main label |
| `Text.Secondary` | supporting label |
| `Text.Tertiary` | low emphasis |
| `Surface.Window` | window content base |
| `Surface.Group` | settings/list group |
| `Surface.Sidebar` | large navigation glass |
| `Surface.Toolbar` | toolbar glass |
| `Surface.Popover` | elevated transient surface |
| `Separator.Subtle` | content separation |
| `Selection.Active` | active window selection |
| `Selection.Inactive` | inactive selection |
| `Accent` | user/app accent |
| `Focus` | keyboard focus |
| `Destructive` | destructive action |

### Typography

**SF Pro를 ship하지 않는다.** Windows 기본은 `Segoe UI Variable` 계열을 사용하고 typography scale만 독립적으로 설계한다. 소비자 override를 허용한다.

Apple font license는 non-Apple OS UI mock-up과 embedding에 제한을 둔다.

**Reference:** https://developer.apple.com/fonts/index.html

### Icons

- Apple SF Symbols 파일을 NuGet에 포함하지 않는다.
- Apple 제품/기능을 묘사하는 copyrighted symbol을 복제하지 않는다.
- 자체 SVG glyph set 또는 명확한 재배포 라이선스가 있는 icon set을 사용한다.
- 우리 glyph는 SF Symbols의 **optical consistency 원칙**(weight, scale, alignment)을 연구하되 path를 복사하지 않는다.

**Reference:** https://developer.apple.com/design/human-interface-guidelines/sf-symbols

---

## 7. Liquid Glass model

Liquid Glass를 `blur + opacity`로 정의하지 않는다.

### 요구 optical properties

1. backdrop sampling
2. diffusion / blur
3. adaptive luminance
4. context-dependent opacity
5. directional/specular edge
6. soft depth shadow
7. weak lensing/refraction impression
8. pointer-dependent highlight
9. press flex / compression / bounce
10. grouping / shared sampling region
11. scroll-edge adaptation
12. accessibility fallback

### Surface taxonomy

```text
Content surfaces
  ├─ Window
  ├─ Group
  ├─ Input field
  └─ Table/list

Functional glass surfaces
  ├─ Sidebar large glass
  ├─ Toolbar glass island
  ├─ Popover glass
  ├─ Interactive glass button
  ├─ Toggle/slider active thumb
  └─ transient floating control
```

**Content surfaces에 glass를 남발하지 않는다.**

### Render modes

| Mode | 조건 | 동작 |
|---|---|---|
| `Full` | Windows 11 + capable compositor + effects allowed | blur/tint/specular/shadow/motion |
| `Reduced` | weak GPU/RDP/power-saving/low effects | lower blur, no advanced lensing |
| `Solid` | High Contrast / effects disabled / unsupported | opaque semantic surface |

`Auto`가 시스템 조건에 따라 위 모드를 선택하는 것이 기본이다.

### WinUI 구현 계층

```text
Glassline.WinUI.Theme
    XAML resources/templates only

Glassline.WinUI.Controls
    composites + behavior

Glassline.WinUI.Effects
    CompositionBackdropBrush
    CompositionEffectBrush
    optional advanced renderer
```

`CompositionBackdropBrush`는 뒤쪽 픽셀을 effect graph input으로 사용할 수 있다.

**Reference:** https://learn.microsoft.com/en-us/windows/windows-app-sdk/api/winrt/microsoft.ui.composition.compositionbackdropbrush

Advanced spatial refraction은 기본 패키지의 필수 조건이 아니다. v1에서는 **좋은 adaptive glass**가 먼저이고, custom D2D/D3D refraction은 별도 R&D gate를 통과할 때만 ship한다.

---
