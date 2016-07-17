;;;; pack-get-data.lisp
;;
;; This package reads the compressed entry from the pack file
;;
(defpackage #:git-api.pack.get-data
  (:use #:cl #:cl-annot.class #:alexandria #:git-api.utils #:static-vectors))


(in-package #:git-api.pack.get-data)
(annot:enable-annot-syntax)

;; imports
(from nibbles import read-ub32/be ub32ref/be read-ub64/be)
(from babel import octets-to-string)


(defparameter *temporary-read-buffer* (make-array 8192
                                                  :element-type '(unsigned-byte 8)
                                                  :fill-pointer t))


(defparameter *temporary-output-buffer* (make-array 8192
                                                    :element-type '(unsigned-byte 8)
                                                    :fill-pointer 0))
@export
(defparameter *use-temporary-output-buffer* t)

@export
(defun get-object-data-old (offset compressed-size uncompressed-size stream)
  "Return the uncompressed data for pack-entry from the opened file stream.
BUFFER is a optional buffer to read compressed data"
  ;; move to position data-offset
  (file-position stream offset)
  (let ((read-buffer
         (if (> compressed-size 8192)
             (make-array compressed-size
                         :element-type '(unsigned-byte 8)
                         :fill-pointer t)
             *temporary-read-buffer*))
        (output-buffer
         (if (and *use-temporary-output-buffer*
                  (<= uncompressed-size 8192))
             (progn
               (setf (fill-pointer *temporary-output-buffer*) 0)
               *temporary-output-buffer*)
             (make-array uncompressed-size 
                         :element-type '(unsigned-byte 8)
                         :fill-pointer 0))))
    ;; sanity check
    (assert (>= (array-total-size read-buffer) compressed-size))
    ;; read the data
    (read-sequence read-buffer stream :end compressed-size)
    ;; uncompress chunk
    (zlib:uncompress read-buffer :output-buffer output-buffer :start 0 :end compressed-size)))




(defparameter *temporary-static-read-buffer* (make-static-vector 8192))


(defparameter *temporary-static-output-buffer* (make-static-vector 8192))

;;; (git-api.zlib-wrapper::uncompress
;;;  (static-vectors:static-vector-pointer out)
;;;  ptr-to-int
;;;  (static-vectors:static-vector-pointer buff)
;;;  (length buff))


;; create unsigned long reference
;;(setq ptr-to-int (cffi:foreign-alloc :unsigned-long))
;; set value of this pointer
;; (setf (cffi:mem-ref ptr-to-int :unsigned-long) (length out))
;; get value of unsigned long reference
;;(cffi:mem-ref ptr-to-int :unsigned-long)

    
;; get value of unsigned long reference
;;(cffi:mem-ref ptr-to-int :unsigned-long)


@export
(defun get-object-data-general (offset compressed-size uncompressed-size stream)
  "Return the uncompressed data for pack-entry from the opened file stream.
BUFFER is a optional buffer to read compressed data"
  ;; move to position data-offset
  (file-position stream offset)
  (let ((read-buffer
         (if (> compressed-size 8192)
             (make-array compressed-size
                         :element-type '(unsigned-byte 8)
                         :fill-pointer t)
             *temporary-read-buffer*))
        (output-buffer
         (if (and *use-temporary-output-buffer*
                  (<= uncompressed-size 8192))
             (progn
               (setf (fill-pointer *temporary-output-buffer*) 0)
               *temporary-output-buffer*)
             (make-array uncompressed-size 
                         :element-type '(unsigned-byte 8)
                         :fill-pointer 0))))
    ;; sanity check
    (assert (>= (array-total-size read-buffer) compressed-size))
    ;; read the data
    (read-sequence read-buffer stream :end compressed-size)
    ;; uncompress chunk
    (zlib:uncompress read-buffer :output-buffer output-buffer :start 0 :end compressed-size)))

@export
(defun get-object-data (offset compressed-size uncompressed-size stream)
  ;; move to position data-offset
  (file-position stream offset)
  (with-static-vector (input compressed-size)
    (with-static-vector (output uncompressed-size)
      (let ((output-buffer
             (make-array uncompressed-size 
                         :element-type '(unsigned-byte 8)))
            (uncompressed-size-ptr
             (cffi:foreign-alloc :unsigned-long)))
        ;; set value of this pointer    
        (setf (cffi:mem-ref uncompressed-size-ptr :unsigned-long) uncompressed-size)
        ;; read the data
        (read-sequence input stream :end compressed-size)
        ;; uncompress chunk
        (let* ((foreign-output (static-vector-pointer output))
               (result
                (git-api.zlib-wrapper::uncompress
                 foreign-output
                 uncompressed-size-ptr
                 (static-vector-pointer input)
                 compressed-size)))
          (unless (= result 0)
            (error (format nil "zlib::uncompress returned ~d" result)))
          (loop for i from 0 below uncompressed-size
                for val = (the (unsigned-byte 8) (cffi:mem-aref foreign-output :unsigned-char i))
                do (setf (aref output-buffer i) val)))
        output-buffer))))
