; extends
((strong_emphasis) @emphasis.inner
  (#offset! @emphasis.inner 0 2 0 -2))

((emphasis) @emphasis.inner
  (#offset! @emphasis.inner 0 1 0 -1))

(strong_emphasis) @emphasis.outer

(emphasis) @emphasis.outer
