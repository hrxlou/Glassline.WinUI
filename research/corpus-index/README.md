# Visual Corpus Index

Target: 50+ public-safe scene records across System Settings, Finder/productivity, Control Center/transient UI, text/input, window/system states, and accessibility-relevant surfaces.

The public repository stores **metadata only**. Do not copy third-party or Apple screenshots, Apple Design Resources exports, fonts, icons, or other licensed reference assets here.

## Initial Tahoe index

The initial corpus is indexed from the public 512 Pixels macOS 26 Tahoe Screenshot Library page. Each CSV row records the source page URL and the scene label exposed by that page. The referenced images are not vendored.

Fields such as appearance, interaction state, and component inventory are deliberately marked as uninspected when the page index alone does not establish them. A corpus row is therefore **not a measurement** and is not evidence for geometry, radius, color, opacity, motion, or material parameters.

Before transferring a corpus row into the measurement ledger:

1. inspect the referenced scene itself;
2. record the exact source/provenance and relevant OS/app context;
3. classify values as Observed, Inferred, or Glassline decision;
4. keep non-redistributable imagery outside the public repository.
