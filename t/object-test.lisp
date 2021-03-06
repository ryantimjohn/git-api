;;;; object-test.lisp
;; NOTE: To run this test file, execute `(asdf:test-system :git-api)' in your Lisp.
;;

(in-package :cl-user)
(defpackage git-api.test.object-test
  (:use :cl
        :alexandria
        :git-api.test.base
        :git-api.utils
        :git-api.object
        :prove))

(in-package git-api.test.object-test)

;; import unexterned(private for package) functions
(from nibbles import write-ub64/be write-ub32/be)
(from git-api.utils import sha1-to-hex)

(from git-api.object import parse-tree-entry parse-text-git-data find-consecutive-newlines)

(defparameter +newlines+ (coerce '(#\newline #\newline) 'string))
 
(defparameter +tag-object-hash+ "f883596e997fe5bcbc5e89bee01b869721326109")
(defparameter +tag-object-size+ 960)
(defparameter +tag-object-data+
  (make-array 1024 :element-type '(unsigned-byte 8) :initial-contents
  '(111 98 106 101 99 116 32 101 48 99 49 99 101 97 102 99 53 98 101 99 101 57
    50 100 51 53 55 55 51 97 55 53 102 102 102 53 57 52 57 55 101 49 100 57
    98 100 53 10 116 121 112 101 32 99 111 109 109 105 116 10 116 97 103 32 118 50
    46 57 46 51 10 116 97 103 103 101 114 32 74 117 110 105 111 32 67 32 72 97
    109 97 110 111 32 60 103 105 116 115 116 101 114 64 112 111 98 111 120 46 99 111
    109 62 32 49 52 55 49 48 49 56 54 55 57 32 45 48 55 48 48 10 10 71
    105 116 32 50 46 57 46 51 10 45 45 45 45 45 66 69 71 73 78 32 80 71
    80 32 83 73 71 78 65 84 85 82 69 45 45 45 45 45 10 86 101 114 115 105
    111 110 58 32 71 110 117 80 71 32 118 49 10 10 105 81 73 99 66 65 65 66
    65 103 65 71 66 81 74 88 114 102 97 51 65 65 111 74 69 76 67 49 54 73
    97 87 114 43 98 76 76 89 56 81 65 78 69 56 90 97 76 43 113 121 104 106
    67 56 102 72 102 74 104 104 114 52 99 89 10 71 101 90 101 56 120 57 83 83
    84 78 118 48 87 122 79 118 88 71 102 51 52 88 119 100 112 79 89 89 105 86
    114 85 114 119 108 103 66 120 54 72 103 108 104 68 101 89 122 67 112 52 107 79
    98 82 53 115 72 119 116 84 75 103 78 10 114 48 75 75 118 65 117 118 106 108
    90 74 109 53 116 87 78 97 118 117 50 102 68 111 72 75 104 69 43 81 82 80
    51 65 97 103 97 70 53 105 68 88 54 56 81 76 106 104 71 79 83 56 43 122
    65 87 113 78 82 117 107 104 55 121 10 88 54 116 109 100 85 104 71 104 87 80
    116 85 75 114 49 76 66 85 86 100 57 52 71 100 70 56 118 53 116 103 103 67
    78 68 99 113 90 90 106 43 100 80 73 111 115 80 118 108 68 113 71 87 84 50
    57 47 73 75 121 67 85 47 97 10 52 111 57 49 104 68 53 106 87 107 77 121
    98 102 121 84 119 122 90 68 115 83 89 109 116 66 52 84 88 120 77 76 56 105
    100 74 85 100 90 81 53 76 121 121 80 113 57 117 83 85 54 51 108 103 80 56
    108 106 119 105 118 89 122 121 10 111 105 86 66 49 79 79 97 119 121 109 55 43
    80 101 121 118 90 69 118 76 118 112 70 87 49 75 115 55 89 83 84 67 77 78
    81 106 110 52 89 51 100 120 89 70 51 115 122 117 111 80 90 86 51 122 116 67
    122 110 103 111 69 73 71 10 113 83 117 122 65 48 115 110 54 122 102 97 77 87
    65 81 70 50 89 106 105 120 50 122 66 102 83 108 66 88 109 120 78 122 65 47
    87 113 89 65 121 78 114 51 76 115 105 97 115 53 65 47 88 57 110 70 116 111
    119 83 69 105 53 54 10 48 105 70 86 105 108 83 115 75 87 99 51 98 67 48
    111 78 69 121 89 70 108 85 115 49 107 89 52 114 82 50 83 53 107 98 66 88
    84 74 54 108 55 53 98 118 68 118 88 80 47 76 43 74 88 109 52 81 99 82
    67 114 57 50 105 10 54 105 55 78 89 120 101 78 113 102 110 90 90 86 55 50
    75 101 71 50 69 113 90 97 76 52 109 114 88 65 89 54 56 77 106 118 56 106
    100 47 56 48 111 111 103 67 85 68 66 104 108 84 75 100 56 73 75 47 87 71
    54 52 77 57 10 86 106 102 72 112 118 75 109 116 107 66 97 73 113 54 90 122
    48 99 81 120 79 49 112 101 52 70 54 52 71 122 83 78 122 108 67 57 108 55
    56 55 105 81 67 110 85 87 43 52 66 79 55 79 121 69 65 66 121 74 87 122
    72 110 43 10 68 53 111 83 102 87 73 55 57 77 68 86 100 118 119 50 85 108
    72 118 107 49 116 103 52 98 78 78 89 76 99 78 119 84 71 90 71 81 104 99
    119 88 117 100 118 55 104 112 122 87 51 115 49 80 66 78 89 48 76 122 88 71
    117 120 10 76 66 79 100 108 86 101 67 99 115 89 71 114 50 114 115 82 77 98
    109 10 61 80 104 84 73 10 45 45 45 45 45 69 78 68 32 80 71 80 32 83
    73 71 78 65 84 85 82 69 45 45 45 45 45 10 119 117 89 54 50 85 110 86
    47 68 108 100 65 53 70 109 99 83 101 111 117 102 86 101 82 83 113 112 71 100
    65 55 70 72 110 83 111 89 108 57 54 104 53 118 43 67 114 86 43 68 121 66
    10 32 109 72 76 73 104 113 78 86 110 50)))

(defparameter +simple-commit-object-data+
  #(116 114 101 101 32 56 101 101 55 52 53 49 51 55 99 53 49 57 51 56 49 57
    52 56 55 48 100 57 48 50 99 100 55 52 102 57 98 99 48 98 101 54 49 56
    102 10 97 117 116 104 111 114 32 65 108 101 120 101 121 32 86 101 114 101 116 101
    110 110 105 107 111 118 32 60 97 108 101 120 101 121 46 118 101 114 101 116 101 110
    110 105 107 111 118 64 103 109 97 105 108 46 99 111 109 62 32 49 52 55 56 55
    50 48 48 51 52 32 43 48 49 48 48 10 99 111 109 109 105 116 116 101 114 32
    65 108 101 120 101 121 32 86 101 114 101 116 101 110 110 105 107 111 118 32 60 97
    108 101 120 101 121 46 118 101 114 101 116 101 110 110 105 107 111 118 64 103 109 97
    105 108 46 99 111 109 62 32 49 52 55 56 55 50 48 48 51 52 32 43 48 49
    48 48 10 10 73 110 105 116 105 97 108 32 105 109 112 111 114 116 10))

(defparameter +simple-commit-object-hash+ "0ec3337eede3a64aaed50f737adf163e9f8d92dc")

(defparameter +simple-commit-object-size+ 217)


(defparameter +empty-commit-object-data+
  #(99 111 109 109 105 116 32 50 53 48 0 116 114 101 101 32 55 51 52 101 100 100 57
    102 101 56 49 53 102 48 56 98 53 50 53 102 50 51 52 50 97 53 48 98 97
    51 57 100 97 53 97 57 100 51 97 100 10 112 97 114 101 110 116 32 56 52 99
    53 99 49 102 55 52 49 101 100 52 101 55 50 102 102 101 55 102 54 49 53 50
    49 49 49 102 99 52 50 56 56 97 54 51 50 99 98 10 97 117 116 104 111 114
    32 65 108 101 120 101 121 32 86 101 114 101 116 101 110 110 105 107 111 118 32 60
    97 108 101 120 101 121 46 118 101 114 101 116 101 110 110 105 107 111 118 64 103 109
    97 105 108 46 99 111 109 62 32 49 52 55 57 55 53 56 54 50 57 32 43 48
    49 48 48 10 99 111 109 109 105 116 116 101 114 32 65 108 101 120 101 121 32 86
    101 114 101 116 101 110 110 105 107 111 118 32 60 97 108 101 120 101 121 46 118 101
    114 101 116 101 110 110 105 107 111 118 64 103 109 97 105 108 46 99 111 109 62 32
    49 52 55 57 55 53 56 54 50 57 32 43 48 49 48 48 10 10))

(defparameter +empty-commit-object-hash+ "26aa178ffc4a43d61373f968a7f36dd642e1724f")
(defparameter +empty-commit-object-size+ 250)
(defparameter +empty-commit-object-start+ 11)


(defparameter +tree-data+
  #(49 48 48 54 52 52 32 108 111 114 101 109 95 49 48 112 46 116 120 116 0 158 239 247 106 170 39 142
    146 83 176 16 109 250 182 184 171 38 25 214 149 49 48 48 54 52 52 32 108 111
    114 101 109 95 51 48 48 119 46 116 120 116 0 222 233 93 99 255 152 188 27 30
    246 226 106 231 216 62 180 13 101 61 62 51 101 57 102 56 100 57 50 100 99 10
    97 117 116 104 111 114 32 65 108 101 120 101 121 32 86 101 114 101 116 101 110 110
    105 107 111 118 32 60 97 108 101 120 101 121 46 118 101 114 101 116 101 110 110 105
    107 111 118 64 103 109 97 105 108 46 99 111 109 62 32 49 52 55 56 55 50 48
    49 50 50 32 43 48 49 48 48 10 99 111 109 109 105 116 116 101 114 32 65 108
    101 120 101 121 32 86 101 114 101 116 101 110 110 105 107 111 118 32 60 97 108 101
    120 101 121 46 118 101 114 101 116 101 110 110 105 107 111 118 64 103 109 97 105 108
    46 99 111 109 62 32 49 52 55 56 55 50 48 49 50 50 32 43 48 49 48 48
    10 10 67 104 97 110 103 101 100 32 116 101 120 116 10 32 102 105 108 101 10 101
    114 111 44 32 98 105 98 101 110 100 117 109 32 115 117 115 99 105 112 105 116 32
    116 111 114 116 111 114 32 100 117 105 32 101 116 32 111 114 99 105 46 32 70 117
    115 99 101 32 110 111 110 32 101 120 32 113 117 105 115 32 113 117 97 109 32 102
    97 117 99 105 98 117 115 32 112 114 101 116 105 117 109 46 32 80 104 97 115 101
    108 108 117 115 32 113 117 105 115 32 108 111 114 101 109 32 101 116 32 116 101 108
    108 117 115 32 101 102 102 105 99 105 116 117 114 32 112 104 97 114 101 116 114 97))
(defparameter +tree-data-size+ 83)
(defparameter +tree-data-hash+ "aca7baf1ea0bc6cc23f92edf55ac2e4ea6586f21")
(defparameter +tree-data-parsed+ 
  '(("100644" "lorem_10p.txt" "9eeff76aaa278e9253b0106dfab6b8ab2619d695")
    ("100644" "lorem_300w.txt" "dee95d63ff98bc1b1ef6e26ae7d83eb40d653d3e")))


(plan nil)


(is-type (parse-git-object :tag +tag-object-data+ +tag-object-hash+ :start 0 :size +tag-object-size+) 'git-api.object:tag)

(subtest "Test parsing of commit without parent"
  (let ((commit
         (parse-git-object :commit (coerce +simple-commit-object-data+ '(vector (unsigned-byte 8)))
                           +simple-commit-object-hash+ :start 0 :size +simple-commit-object-size+)))
    (is-type commit 'git-api.object:commit "Test if parsed object is the instance of commit class")
    (is (object-hash commit) "0ec3337eede3a64aaed50f737adf163e9f8d92dc" :test #'string=
        "Test for commit hash")
    (is (commit-author commit) "Alexey Veretennikov <alexey.veretennikov@gmail.com> 1478720034 +0100"
        :test #'string=
        "Test for commit author")
    (is (commit-committer commit) "Alexey Veretennikov <alexey.veretennikov@gmail.com> 1478720034 +0100"
        :test #'string=
        "Test for commit committer")
    (is (commit-tree commit) "8ee745137c51938194870d902cd74f9bc0be618f" :test #'string=
        "Test for commit tree object")
    (is (commit-parents commit) nil :test #'equalp
        "Test for commit with no parents")
    (is (commit-comment commit) (format nil "Initial import~%") :test #'string=
        "Test for commit comment")))

(subtest "Test parsing of commit with empty comment"
  (let ((commit
         (parse-git-object :commit (coerce +empty-commit-object-data+ '(vector (unsigned-byte 8)))
                           +empty-commit-object-hash+ :start +empty-commit-object-start+ :size +empty-commit-object-size+)))
    (is-type commit 'git-api.object:commit "Test if parsed object is the instance of commit class")
    (is (object-hash commit) "26aa178ffc4a43d61373f968a7f36dd642e1724f" :test #'string=
        "Test for commit hash")
    (is (commit-author commit) "Alexey Veretennikov <alexey.veretennikov@gmail.com> 1479758629 +0100"
        :test #'string=
        "Test for commit author")
    (is (commit-committer commit) "Alexey Veretennikov <alexey.veretennikov@gmail.com> 1479758629 +0100"
        :test #'string=
        "Test for commit committer")
    (is (commit-tree commit) "734edd9fe815f08b525f2342a50ba39da5a9d3ad" :test #'string=
        "Test for commit tree object")
    (is (commit-parents commit) '("84c5c1f741ed4e72ffe7f6152111fc4288a632cb") :test #'equalp
        "Test for parent commit")
    (is (commit-comment commit) "" :test #'string=
        "Test for commit comment")
    ;; test print
    (let* ((lines
           '("commit: 26aa178ffc4a43d61373f968a7f36dd642e1724f"
             "tree 734edd9fe815f08b525f2342a50ba39da5a9d3ad"
             "author Alexey Veretennikov <alexey.veretennikov@gmail.com> 1479758629 +0100"
             "committer Alexey Veretennikov <alexey.veretennikov@gmail.com> 1479758629 +0100"
             "parents 84c5c1f741ed4e72ffe7f6152111fc4288a632cb"
             "comment"))
           (expected (with-output-to-string (s)
                       (dolist (line lines) (write-line line s)))))
    (is-print (format t "~a" commit) expected
                 "Test of print function of the commit object"))))


(subtest "Testing of the parsing of tree objects"
  (flet ((compare-entries (entry parsed-entry)
           (and (string= (tree-entry-mode entry) (car parsed-entry))
                (string= (tree-entry-name entry) (cadr parsed-entry))
                (string= (tree-entry-hash entry) (caddr parsed-entry)))))
    (let ((tree
           (parse-git-object :tree (coerce +tree-data+ '(vector (unsigned-byte 8)))
                             +tree-data-hash+ :start 0 :size +tree-data-size+)))
      (is-type tree 'git-api.object:tree "Test if parsed object is the instance of tree class")
      (is-type (tree-entries tree) 'list "Test if tree entries are not null")
      (is (length (tree-entries tree)) 2 "Test the number of tree entries")
      (loop for entry in (tree-entries tree)
            for parsed-entry in +tree-data-parsed+
            for i = 1 then (incf i)
            do
            (is entry parsed-entry :test #'compare-entries (format nil "Compare tree entry ~d" i))))))


(subtest "Testing of parse-tree-entry"
  (let* ((mode "100100")
         (fname "mycoolfile.txt")
         (header (babel:string-to-octets (concatenate 'string mode " " fname)))
         (hash #(49 48 48 54 52 52 32 108 111 114 101 109 95 49 48 112 46 116 120 116 ))
         ;; create an entry with some initial bytes
         (entry (coerce (concatenate 'vector #(1 2 3) header #(0) hash) '(vector (unsigned-byte 8)))))
    (let ((parsed-entry (parse-tree-entry entry 3)))
      (is-type parsed-entry 'cons "Check if parsed entry result is a cons")
      (is-type (car parsed-entry) 'git-api.object::tree-entry "Check if a parsed entry is has a proper type")
      (is (tree-entry-hash (car parsed-entry)) (sha1-to-hex hash) :test #'string= "Check hash")
      (is (tree-entry-mode (car parsed-entry)) mode :test #'string= "Check mode")
      (is (tree-entry-name (car parsed-entry)) fname :test #'string= "Check name")
      (is (cdr parsed-entry) (length entry)
          "Check the position of the next tree entry is correct"))))


(subtest "Testing of find-consecutive-newlines"
  (let* ((normal-case
          (concatenate 'string "123456" +newlines+ "abcd"))
         (no-newlines "123456abcd")
         (one-newline-at-end (concatenate 'string "123456" #(#\newline)))
         (newlines-at-end (concatenate 'string "123456" +newlines+))
         (newlines-at-beginning (concatenate 'string +newlines+ "123456")))
    (is (find-consecutive-newlines normal-case) 6 "Check if newlines found")
    (is (find-consecutive-newlines normal-case :first 2) 6 "Check if newlines with nonzero start")
    (is (find-consecutive-newlines normal-case :first 1 :last 5) 5 "Check if newlines with notzero end")
    (is (find-consecutive-newlines no-newlines) (length no-newlines) "Check no newlines return length of the string")
    (is (find-consecutive-newlines no-newlines :first 2) (length no-newlines) "Check no newlines in shifed string")
    (is (find-consecutive-newlines one-newline-at-end) (length one-newline-at-end) "Check when only one newline at the end")
    (is (find-consecutive-newlines newlines-at-beginning) 0 "Check when only one newline at the beginning")
    (is (find-consecutive-newlines newlines-at-end) (- (length newlines-at-end) 2) "Check when only one newline at the beginning")
    (is (find-consecutive-newlines newlines-at-beginning :first 20 :last 20) 20 "Check when first = last")))



(subtest "Testing of parse-text-git-data"
  (let* ((header (concatenate 'string "aaaline1" #(#\newline) "line2"))
         (comment1 "hello")
         (comment2 "")
         (comment3 (concatenate 'string "comment" #(#\newline))))
    (let* ((data1 (babel:string-to-octets (concatenate 'string header +newlines+ comment1)))
           (parsed1 (parse-text-git-data data1 3 (- (length data1) 3))))
      (is (caar parsed1) "line1" :test #'string= "Test of the header line 1")
      (is (cadar parsed1) "line2" :test #'string= "Test of the header line 2")
      (is (cdr parsed1) comment1 :test #'string= "Test of comment 1"))
    (let* ((data2 (babel:string-to-octets (concatenate 'string header +newlines+ comment2)))
           (parsed2 (parse-text-git-data data2 3 (- (length data2) 3))))
      (is (caar parsed2) "line1" :test #'string= "Test of the header line 1")
      (is (cadar parsed2) "line2" :test #'string= "Test of the header line 2")
      (is (cdr parsed2) comment2 :test #'string= "Test of comment 2"))
    (let* ((data3 (babel:string-to-octets (concatenate 'string header +newlines+ comment3)))
           (parsed3 (parse-text-git-data data3 3 (- (length data3) 3))))
      (is (caar parsed3) "line1" :test #'string= "Test of the header line 1")
      (is (cadar parsed3) "line2" :test #'string= "Test of the header line 2")
      (is (cdr parsed3) comment3 :test #'string= "Test of comment 3"))))



(subtest "Testing of parse-git-file"
  (let ((parsed1 
         (parse-git-file (namestring (testfile "example-objects/52/00e67faf9a9a39b916f7779fe98bcaa47eda0c"))))
        (parsed2
         (parse-git-file (namestring (testfile "example-objects/52/4acfffa760fd0b8c1de7cf001f8dd348b399d8")))))
    (is-type parsed1 'git-api.object::commit "Check the parsed commit type")
    (is-type
     (parse-git-file (testfile "example-objects/52/00e67faf9a9a39b916f7779fe98bcaa47eda0c"))
     'git-api.object::commit "Check the parsed commit type with a name as pathname")
    (is-type parsed2 'git-api.object::blob "Check the parsed blob type")
    (print parsed2)
    (is (babel:octets-to-string (blob-content parsed2) ) (concatenate 'string "Test file" '(#\newline))
        :test #'string= "Test of the blob file contents")))



(finalize)
