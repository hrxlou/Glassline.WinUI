# Project Principles

# 35. 최종 프로젝트 원칙 한 장 요약

```text
DO
✓ Pure WinUI 3
✓ Windows 11 native behavior
✓ semantic tokens
✓ Apple UI를 연구해 독립적으로 재해석
✓ functional glass only where it adds hierarchy
✓ Windows caption semantics in the system-reserved trailing corner (LTR right, RTL left)
✓ Light/Dark/High Contrast를 처음부터
✓ screenshot + UIA + IME + perf CI
✓ visual generation을 version으로 고정
✓ zero unlicensed Apple assets

DON'T
✗ SwiftUI clone API
✗ macOS 앱 pixel clone
✗ SF Pro/SF Symbols bundling
✗ traffic lights를 오른쪽에 옮기는 혼성 문법
✗ 모든 panel에 blur/border/shadow
✗ advanced refraction을 release blocker로 만들기
✗ native TextBox/IME semantics 재구현
✗ license 없는 Tahoe.Avalonia code 복사
```

**v1의 핵심은 “Apple처럼 보이는 버튼”이 아니라, Windows 앱 개발자가 별도 UI framework 없이 사용할 수 있는 coherent desktop visual system을 만드는 것이다.**
