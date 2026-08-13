# Validation Engineering

# Part F — Validation engineering

## 18. Visual regression strategy

### Baseline 종류

1. **Reference baseline** — 실제 macOS / AppleReferenceLab. 배포 artifact 아님.
2. **Glassline golden baseline** — 우리 Gallery screenshot. CI에 저장.
3. **Interaction baseline** — press/open/close animation keyframe/gif/video.

### CI image matrix

- Light / Dark
- active / inactive
- accent blue + graphite-like neutral + one alternate accent
- Full / Reduced / Solid effect modes
- 100 / 150 / 200% scale의 대표 subset

### 승인 방식

pixel diff 하나로 승인하지 않는다.

- perceptual diff
- geometry diff
- semantic reviewer checklist
- known antialiasing tolerance

**목표는 Apple screenshot과의 pixel score가 아니라, Glassline golden baseline이 의도 없이 변하지 않는 것**이다.

---

## 19. Accessibility / input matrix

### Native control 우선 이유

ControlTemplate만 바꾸면 WinUI가 제공하는 input/accessibility logic를 최대한 보존할 수 있다.

### Custom control 의무

- AutomationPeer
- keyboard navigation
- focus order
- name / role / state / value
- high contrast
- text scaling
- RTL
- localization
- disabled/selected semantics
- touch/pointer
- drag/drop

### IME matrix

- Korean 2-set
- Japanese IME composition / candidate window
- Simplified Chinese Pinyin composition
- emoji / symbol insertion
- password field behavior

Text input visual을 새로 만들더라도 **실제 WinUI TextBox/AutoSuggestBox를 내부 입력 엔진으로 유지**한다.

---

## 20. Performance plan

성능 budget은 reference hardware를 M0에 고정한 뒤 CI 기준으로 확정한다. 초기 목표:

- standard interactive scene: 60 Hz에서 visible jank 없음
- resize 중 effect chain이 layout thread를 blocking하지 않음
- virtualized List/Tree scroll에서 glass layer가 item virtualization을 깨지 않음
- inactive/background window의 animation 최소화
- RDP / low-end GPU / effects-disabled에서 자동 Reduced/Solid downgrade
- compositor resource leak 0
- grouped controls use shared material regions rather than per-control live backdrop pipelines

### Material-specific runtime rules

- Normal capable local session may use `Full`.
- Continuous window resize must temporarily use `Reduced` for expensive material work: advanced refraction off, blur/effect complexity reduced, nonessential continuous pointer/specular animation suppressed.
- Inactive/background windows stop nonessential continuous material animation and may use a cheaper/static material state.
- High Contrast/effects-disabled forces `Solid`.
- Slow/unsupported composition effects must switch to a simpler graph instead of attempting the Full graph.
- Virtualized rows/items use semantic fills for normal/hover/selection and do not own independent live backdrop brushes.

### Benchmark scenes

1. Settings 100 rows + one sidebar region + toolbar region
2. productivity/file-browser grid 500 items + selection + scrolling
3. Tree 5k nodes lazy expanded
4. Popover/menu rapid open-close
5. continuous window resize 10s with mode-transition trace
6. Light↔Dark / active↔inactive transition
7. multi-window scene: active + inactive/background window
8. glass-region stress scene: same visible UI rendered with grouped regions vs deliberately fragmented regions for diagnostic comparison

### Required measurements

Release-performance evidence should record, where the selected tooling can capture it reliably:

- frame-time P50 / P95 / P99;
- process memory delta;
- GPU utilization;
- GPU memory delta;
- power/energy signal when available;
- active glass-region count;
- total glass pixel area or percentage of window area;
- material mode (`Full`, `Reduced`, `Solid`);
- refraction enabled/disabled;
- active/inactive and resize state.

The cost model to watch is approximately **glass area × region count × effect complexity × update frequency**. FPS alone is not sufficient evidence.

### M2 material gate

The M2 Glass Engine does not pass merely because a single isolated panel looks correct. It must demonstrate:

- stable Sidebar + Toolbar together;
- predictable Full → Reduced → Solid transitions;
- no per-row live backdrop strategy in virtualized data scenes;
- no advanced refraction requirement for visual coherence;
- continuous resize remains responsive with the Reduced policy;
- inactive/background material activity is measurably lower or static;
- no compositor resource leak across repeated open/close/theme/state transitions.

Release 전에 measurements, resize behavior, material mode transitions, and region counts are written to `PERF_BUDGET.md`/trace artifacts. Numeric budgets are locked after benchmark hardware is selected.

---

## 21. Test project layout

```text
tests/
├─ Glassline.UnitTests/
├─ Glassline.ResourceTests/
├─ Glassline.VisualTests/
├─ Glassline.AutomationTests/
├─ Glassline.InputTests/
├─ Glassline.PerformanceTests/
└─ baselines/
   ├─ light/
   ├─ dark/
   ├─ solid/
   └─ interaction/
```

### CI minimum

- build x64 + ARM64
- pack NuGet
- unit/resource tests
- deterministic Gallery launch
- selected screenshot baselines
- API compatibility check
- dependency license/SBOM generation
- package content scan for forbidden assets

---
