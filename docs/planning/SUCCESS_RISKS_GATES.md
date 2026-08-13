# Success, Risk & Decision Gates


# Part I — Success, risk and decision gates

## 30. 프로젝트 성공 기준

### Engineering

- P0 ordinary WinUI controls가 implicit theme만으로 usable
- Core Theme에 Uno/Avalonia renderer dependency 0
- text input/IME/accessibility가 native WinUI behavior를 유지
- Windows 11 caption/Snap/system menu와 충돌하지 않음

### Visual

- Light/Dark 둘 다 legacy glossy/XP 또는 generic Fluent skin으로 읽히지 않음
- glass는 neutral gray plastic이 아니라 background/context에 반응
- Settings/productivity archetype이 모두 coherent
- hard border 없이도 hierarchy가 읽힘

### Product

새 앱이 다음 정도로 시작 가능해야 한다.

```xml
<glassline:GlasslineResources UseImplicitStyles="True" />
```

그리고 ordinary WinUI controls로 기본 visual consistency가 확보되어야 한다.

---

## 31. Risk register

| Risk | 영향 | 대응 |
|---|---|---|
| Glass가 cheap/glossy하게 보임 | 매우 큼 | material taxonomy + visual gate + corpus comparison |
| Effects가 resize/scroll 성능 저하 | 큼 | Auto Reduced/Solid fallback, advanced refraction optional |
| WinAppSDK update가 template 깨뜨림 | 큼 | pinned stable, compatibility CI, generation/version policy |
| Custom control이 UIA/IME를 깨뜨림 | 매우 큼 | native control composition 우선, Automation tests |
| Apple asset/trademark 문제 | 매우 큼 | zero Apple asset policy + release IP gate |
| Tahoe.Avalonia/Uno가 빠르게 따라옴 | 중간 | quarterly competitor review, WinUI-native focus 유지 |
| 너무 많은 control scope | 큼 | P0/P1/P2 strict gates |
| 디자인이 Apple clone으로 보임 | 큼 | Windows interaction semantics + own tokens/icons/content IA |

---

## 32. Kill / pivot criteria

다음 조건이면 범위를 줄이거나 방향을 재검토한다.

1. **M2 종료 후** adaptive glass가 Windows compositor에서 안정적인 품질/성능을 내지 못하면 advanced refraction을 v1에서 제거한다.
2. **M4 종료 후** Settings + productivity archetype이 Uno/Devolutions 대비 명확한 visual/desktop 이점을 보이지 않으면 full design-system scope를 재평가한다.
3. custom control이 native IME/UIA를 반복적으로 훼손하면 composite를 포기하고 WinUI base control customization으로 후퇴한다.
4. public release 전 IP review에서 특정 visual element가 고위험으로 판단되면 해당 element를 더 독립적인 Glassline language로 변경한다.
5. cross-platform requirement가 핵심 제품 요구가 되면 Uno/Avalonia 채택을 다시 평가한다. Pure WinUI라는 현재 architecture를 억지로 확장하지 않는다.

---

## 33. Open decisions

프로젝트 bootstrap 때 확정할 것:

- [x] 최종 product/package name — `Glassline.WinUI`
- [x] repository license — MIT
- [x] current stable WinAppSDK exact pin — 2.3.1
- [ ] Windows 11 minimum build
- [ ] C++/WinRT support를 v1에서 Theme package까지만 공식화할지
- [ ] icon set: 완전 자체 제작 vs permissive OSS base
- [ ] preview NuGet feed 위치
- [ ] screenshot CI runner / GPU reference hardware
- [ ] visual reviewer 2인 승인 여부
- [x] commercial vs OSS-first distribution — OSS-first for project-authored code/docs

결정 후 ADR로 승격한다.

---
