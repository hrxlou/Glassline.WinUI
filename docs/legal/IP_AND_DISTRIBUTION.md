# IP, Licensing & Distribution


## Repository license and project identity

- Project-authored code and documentation are released under the **MIT License** in the repository root.
- The MIT License does **not** relicense third-party source or reference material kept outside the repository.
- Public naming/attribution follows [`TRADEMARKS.md`](TRADEMARKS.md).
- `Glassline.WinUI` is an independent project name; Microsoft and Apple product names are descriptive references only.

# Part H — IP, licensing, and distribution gate

> 이 섹션은 제품 개발용 위험 관리 기준이며 법률 자문을 대체하지 않는다.

## 25. Apple asset policy

### Shipping package에 금지

- Apple logo
- Apple product artwork
- SF Pro / SF Compact / New York font file
- SF Symbols exported paths/assets
- Apple Design Resources의 Figma/Sketch component export
- System Settings / Finder 등의 Apple screenshot
- Apple 앱 icon

### 내부 연구에서만 허용

- Apple HIG / WWDC 열람
- 512 Pixels 등 screenshot corpus 비교
- Apple Design Resources를 **해당 라이선스 범위에서** 연구 참고
- AppleReferenceLab screenshot

공개 repository에는 가능하면 원본 reference asset 대신 **source URL + measurement + 우리 decision**만 남긴다.

```text
.local-research/reference-material/  # not committed
research/measurements/                  # commit OK
samples/Glassline.Gallery/                   # only our rendered UI
```

---

## 26. Trademark / naming policy

Apple의 2026-07-14 기준 trademark list에는 `Aqua`, `macOS`, `Swift`, `SwiftUI` 등이 포함된다.

피할 이름:

- `SwiftUI for Windows`
- `macOS.WinUI`
- `Aqua.WinUI`
- `FinderUI`
- `AppleUI`

권장:

- 독립 brand + `.WinUI`

마케팅 문구는 affiliation을 암시하지 않는다.

예:

> “A native WinUI 3 design system inspired by contemporary desktop interface conventions.”

Apple 비교가 필요하면 설명 문맥에서만 사실적으로 언급하고 trademark attribution을 검토한다.

References:

- https://www.apple.com/legal/intellectual-property/trademark/appletmlist.html
- https://www.apple.com/legal/intellectual-property/guidelinesfor3rdparties.html

---

## 27. External code provenance policy

### Uno.Themes

Apache-2.0이므로 조건을 지키면 재사용 가능하지만, **v1 기본 정책은 clean implementation**이다.

이유:

- attribution 관리 단순화
- Apple-specific visual decision과 Uno implementation을 분리
- cross-platform abstraction residue 방지

직접 코드를 가져올 경우:

- SPDX/source provenance 기록
- Apache license/notice 유지
- 수정 파일 표시
- legal review

### Tahoe.Avalonia

현재 repository에 license가 확인되지 않으므로 **source code copying 금지**.

### 다른 프로젝트

코드/asset 사용 전 `THIRD-PARTY.yml`에 기록한다.

```yaml
name: example
source: https://...
license: MIT
used_in: icons/foo.svg
modified: true
reviewed_by: ...
review_date: ...
```

---

## 28. GUI similarity risk policy

우리 목표는 **Apple 화면 복제 상품**이 아니라 Windows용 독립 디자인 시스템이다.

위험을 줄이는 제품 결정:

- right-side Windows caption semantics
- 자체 typography metrics
- 자체 icon paths
- 자체 glass shader/effect values
- 자체 spacing/radius token scale
- Windows keyboard/focus/high-contrast conventions
- sample apps도 실제 System Settings/Finder 전체 화면을 1:1 복제하지 않음

특정 Apple 앱의 전체 화면을 pixel-match하는 것은 research-only validation에서만 사용하고 public Gallery는 **다른 information architecture/content**를 사용한다.

공개 상용 release 전에는 주요 market(예: US/KR/EU)에 대해 IP 전문가의 clearance를 받는 것을 권장한다.

---

## 29. Release IP gate

stable publish 전에 전부 확인:

- [ ] package name / logo independent
- [ ] Apple trademark가 product name에 없음
- [ ] Apple font file 없음
- [ ] SF Symbols export 없음
- [ ] Apple UI Kit export 없음
- [ ] Apple screenshots 없음
- [ ] all icons have provenance/license
- [ ] all third-party source has SPDX/license/notice
- [ ] `THIRD-PARTY-NOTICES` 생성
- [ ] NuGet package content scan 통과
- [ ] sample app information architecture가 Apple 앱 clone이 아님
- [ ] README가 Apple affiliation을 암시하지 않음
- [ ] commercial launch라면 legal clearance 완료

---
