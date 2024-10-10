# Changelog

## [Unreleased]

- `XMP.new` and `.parse` return an empty XMP::Document when a JPEG or TIFF image has no XMP metadata.
  (In 0.2 and earlier, those methods returned `nil` in that case.
  In 1.0 and 1.0.1 they intended to raise a custom exception, but raised `NoMethodError`.)
- Add `XMP::Document#empty?`

## 1.0.1

- Reinstate support for Ruby 2.6 (the version included with current macOS, macOS 14, Sonoma)
- Fix unintended exception, introduced in 1.0, in `XMP::Document#respond_to_missing?` and
  `XMP::Namespace#respond_to_missing?`

## 1.0

- Support TIFF images
- Support standalone properties with attributes, for example `Iptc4xmpCore.CreatorContactInfo`
- Namespaces and attributes may be accessed with more Ruby-style underscore identifiers,
  for example ExampleNamespace as example_namespace
- `XMP.new` and `.parse` accept `Pathname` and `File` as well as a `String` path
- Remove support for Ruby 2.6 and earlier
