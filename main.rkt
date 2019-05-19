#lang racket
(require "lib.rkt")

(for ([lst (racket-word-freq)])
  (displayln lst))