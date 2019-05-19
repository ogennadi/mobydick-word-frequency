#lang racket
(provide racket-word-freq stop-words moby-words count-frequency)

(define STOP-WORDS-FILE "stop-words.txt")
(define MOBYDICK-FILE "mobydick.txt")
(define TOP-N 100)

(define (stop-words)
  (let ([junk-in-stop-words-file? (lambda (x)
                                    (or (equal? x "") (string-prefix? x "#")))])
    (filter-not junk-in-stop-words-file? (file->lines STOP-WORDS-FILE))))

(define (moby-words)
  
  (define (expand-number-acronym str)
    (if (string-prefix? str "1.")
        (string-split str ".")
        str))
  
  (let* ([rough-tokens      (string-split (file->string MOBYDICK-FILE) #px"[-\uFEFF/:\\@“”!?;—\\s\\$\\*\\(\\)]+")]
         [trim              (lambda (str) (string-trim str #px"[\\[‘’:&%.,\\]\\(\\)\\s]+"))]
         [lowercase-trimmed (map (compose string-downcase trim) rough-tokens)]
         [smooth-tokens     (flatten (map expand-number-acronym lowercase-trimmed))]
         [non-tokens        '("#2701" "")])
    (remove* non-tokens smooth-tokens)))

;; https://stackoverflow.com/a/5741004/2042190
(define (count-frequency lst)
  (foldl (lambda (key ht)
           (hash-update ht key add1 0))
         #hash() lst))

(define (racket-word-freq)
  (let* ([freq-hash   (count-frequency (remove* (stop-words) (moby-words)))]
         [freq-list   (hash-map freq-hash list)]
         [sorted-list (sort freq-list > #:key last)])
    (take sorted-list TOP-N)))