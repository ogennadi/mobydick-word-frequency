#lang racket
(require "lib.rkt")

(for ([assoc (racket-word-freq)])
  (displayln assoc))