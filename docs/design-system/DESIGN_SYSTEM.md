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

## 7. Material model

Liquid Glass를 `blur + opacity`로 정의하지 않는다. Glassline의 목표는 Windows-native foundation 위에 adaptive functional material을 추가하는 것이다.

### Foundation vs functional material

```text
Foundation / content
  ├─ Window: system Mica when supported/appropriate
  ├─ Solid fallback
  ├─ Group
  ├─ Input field
  └─ Table/list

Functional glass
  ├─ Sidebar
  ├─ Toolbar island/group
  ├─ Popover/flyout
  ├─ Interactive glass group
  ├─ Toggle/slider active thumb where justified
  └─ transient floating control
```

Mica is the preferred low-cost window foundation when Windows allows it; it is not treated as a live effect for every content element. Settings rows, table rows, normal list items, and text fields remain standard semantic surfaces.

**Content surfaces에 glass를 남발하지 않는다.**

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

### Shared material region rule

Adjacent controls that visually form one glass group should be rendered through a shared `GlassContainer`-style region. The final API name may change before preview, but one toolbar group should not normally allocate a separate live backdrop/effect graph for every button.

Typical shared regions:

- Sidebar region
- Toolbar/command island
- Popover/flyout
- Selected floating interactive group

This is an architectural performance rule as well as a visual rule: the unit to minimize is **active glass region count and total glass area**, not just the number of controls.

### Semantic material roles

Public styling should target roles such as:

- `Sidebar`
- `Toolbar`
- `Popover`
- `Interactive`
- `Prominent`

Raw values such as blur radius, tint opacity, displacement amount, and shader frequency remain internal implementation details by default. This allows the material to adapt by capability, accessibility, design generation, and backdrop context.

### Render modes

| Mode | 조건 | 동작 |
|---|---|---|
| `Full` | capable local compositor + effects allowed | blur/tint/luminance/specular/shadow/motion; only approved optional lensing |
| `Reduced` | resize/weak or slow effects/RDP/power or policy constraint | lower-cost effect graph, lower blur, no advanced lensing, reduced continuous animation |
| `Solid` | High Contrast / effects disabled / unsupported | opaque semantic surface + explicit separators |

`Auto`가 시스템 조건에 따라 위 모드를 선택하는 것이 기본이다.

### Runtime quality transitions

- continuous resize: temporarily downgrade to `Reduced`; disable refraction and nonessential continuous pointer/specular animation; restore after resize settles;
- inactive/background window: suppress nonessential continuous material animation and allow a cheaper/static state;
- High Contrast/effects disabled: force `Solid`;
- unsupported or slow composition effects: select a simpler graph instead of attempting Full quality.

### Explicit anti-patterns

- `ListViewItem`/`TreeViewItem`/data-row마다 backdrop blur를 만들지 않는다.
- grouped toolbar button마다 독립 effect graph를 만들지 않는다.
- full-window real-time refraction을 기본 디자인으로 사용하지 않는다.
- glass-on-glass nesting을 기본 패턴으로 만들지 않는다.
- inactive/background windows에서 continuous optical animation을 유지하지 않는다.
- resize 중 advanced refraction을 유지하지 않는다.

### WinUI 구현 계층

```text
Glassline.WinUI.Theme
    XAML resources/templates + semantic content/fallback surfaces

Glassline.WinUI.Controls
    composites + behavior + shared material-region primitive

Glassline.WinUI.Effects
    optional advanced Composition/optical renderer
    experimental refraction/lensing
```

Baseline material work should rely on Windows App SDK/Composition. Advanced spatial refraction is not a basic package requirement.

`CompositionBackdropBrush` can supply sampled pixels to a Composition effect graph.

**References:**

- https://learn.microsoft.com/windows/apps/develop/ui/system-backdrops
- https://learn.microsoft.com/windows/apps/develop/composition/composition-brushes
- https://learn.microsoft.com/windows/uwp/composition/composition-tailoring

Advanced spatial refraction은 기본 패키지의 필수 조건이 아니다. v1에서는 **좋은 adaptive glass**가 먼저이고, custom D2D/D3D refraction은 별도 R&D gate를 통과할 때만 ship한다.

Detailed implementation contract: [`../architecture/MATERIAL_ARCHITECTURE.md`](../architecture/MATERIAL_ARCHITECTURE.md).

---
