(use-package format-all
  :ensure t)

(use-package autorevert
  :ensure nil
  :diminish
  :hook (after-init . global-auto-revert-mode))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region)
  :config
  (defun tree-sitter-mark-bigger-node ()
    (interactive)
    (let* ((root (tsc-root-node tree-sitter-tree))
         (node (tsc-get-descendant-for-position-range root (region-beginning) (region-end)))
         (node-start (tsc-node-start-position node))
         (node-end (tsc-node-end-position node)))
    ;; Node fits the region exactly. Try its parent node instead.
    (when (and (= (region-beginning) node-start) (= (region-end) node-end))
      (when-let ((node (tsc-get-parent node)))
        (setq node-start (tsc-node-start-position node)
              node-end (tsc-node-end-position node))))
    (set-mark node-end)
    (goto-char node-start)))

    (setq er/try-expand-list (append er/try-expand-list
                                 '(tree-sitter-mark-bigger-node)))
)

;; Jump to things in Emacs tree-style
(use-package avy
  :ensure t
  ;; :bind (("C-:"   . avy-goto-char)
         ;; ("C-'"   . avy-goto-char-3)
         ;; ("M-g l" . avy-goto-line)
         ;; ("M-g w" . avy-goto-word-2)
         ;; ("M-g e" . avy-goto-word-1))
  :hook (after-init . avy-setup-default)
  :config (setq avy-all-windows nil
                avy-all-windows-alt t
				avy-words '("ff" "fj" "jf" "fd" "jj" "df" "fk" "jd" "dj" "kf" "fs" "jk" "dd" "kj" "sf" "fl" "js" "dk" "kd" "sj" "lf" "fa" "jl" "ds" "kk" "sd" "lj" "af" "fh" "ja" "dl" "ks" "sk" "ld" "aj" "hf" "fg" "jh" "da" "kl" "ss" "lk" "ad" "hj" "gf" "fy" "jg" "dh" "ka" "sl" "ls" "ak" "hd" "gj" "yf" "fq" "jy" "dg" "kh" "sa" "ll" "as" "hk" "gd" "yj" "qf" "fu" "jq" "dy" "kg" "sh" "la" "al" "hs" "gk" "yd" "qj" "uf" "fw" "ju" "dq" "ky" "sg" "lh" "aa" "hl" "gs" "yk" "qd" "uj" "wf" "fi" "jw" "du" "kq" "sy" "lg" "ah" "ha" "gl" "ys" "qk" "ud" "wj" "if" "fe" "ji" "dw" "ku" "sq" "ly" "ag" "hh" "ga" "yl" "qs" "uk" "wd" "ij" "ef" "fr" "je" "di" "kw" "su" "lq" "ay" "hg" "gh" "ya" "ql" "us" "wk" "id" "ej" "rf" "fo" "jr" "de" "ki" "sw" "lu" "aq" "hy" "gg" "yh" "qa" "ul" "ws" "ik" "ed" "rj" "of" "fp" "jo" "dr" "ke" "si" "lw" "au" "hq" "gy" "yg" "qh" "ua" "wl" "is" "ek" "rd" "oj" "pf" "ft" "jp" "do" "kr" "se" "li" "aw" "hu" "gq" "yy" "qg" "uh" "wa" "il" "es" "rk" "od" "pj" "tf" "fn" "jt" "dp" "ko" "sr" "le" "ai" "hw" "gu" "yq" "qy" "ug" "wh" "ia" "el" "rs" "ok" "pd" "tj" "nf" "fz" "jn" "dt" "kp" "so" "lr" "ae" "hi" "gw" "yu" "qq" "uy" "wg" "ih" "ea" "rl" "os" "pk" "td" "nj" "zf" "fm" "jz" "dn" "kt" "sp" "lo" "ar" "he" "gi" "yw" "qu" "uq" "wy" "ig" "eh" "ra" "ol" "ps" "tk" "nd" "zj" "mf" "fx" "jm" "dz" "kn" "st" "lp" "ao" "hr" "ge" "yi" "qw" "uu" "wq" "iy" "eg" "rh" "oa" "pl" "ts" "nk" "zd" "mj" "xf" "fc" "jx" "dm" "kz" "sn" "lt" "ap" "ho" "gr" "ye" "qi" "uw" "wu" "iq" "ey" "rg" "oh" "pa" "tl" "ns" "zk" "md" "xj" "cf" "fv" "jc" "dx" "km" "sz" "ln" "at" "hp" "go" "yr" "qe" "ui" "ww" "iu" "eq" "ry" "og" "ph" "ta" "nl" "zs" "mk" "xd" "cj" "vf" "fb" "jv" "dc" "kx" "sm" "lz" "an" "ht" "gp" "yo" "qr" "ue" "wi" "iw" "eu" "rq" "oy" "pg" "th" "na" "zl" "ms" "xk" "cd" "vj" "bf" "jb" "dv" "kc" "sx" "lm" "az" "hn" "gt" "yp" "qo" "ur" "we" "ii" "ew" "ru" "oq" "py" "tg" "nh" "za" "ml" "xs" "ck" "vd" "bj" "db" "kv" "sc" "lx" "am" "hz" "gn" "yt" "qp" "uo" "wr" "ie" "ei" "rw" "ou" "pq" "ty" "ng" "zh" "ma" "xl" "cs" "vk" "bd" "kb" "sv" "lc" "ax" "hm" "gz" "yn" "qt" "up" "wo" "ir" "ee" "ri" "ow" "pu" "tq" "ny" "zg" "mh" "xa" "cl" "vs" "bk" "sb" "lv" "ac" "hx" "gm" "yz" "qn" "ut" "wp" "io" "er" "re" "oi" "pw" "tu" "nq" "zy" "mg" "xh" "ca" "vl" "bs" "lb" "av" "hc" "gx" "ym" "qz" "un" "wt" "ip" "eo" "rr" "oe" "pi" "tw" "nu" "zq" "my" "xg" "ch" "va" "bl" "ab" "hv" "gc" "yx" "qm" "uz" "wn" "it" "ep" "ro" "or" "pe" "ti" "nw" "zu" "mq" "xy" "cg" "vh" "ba" "hb" "gv" "yc" "qx" "um" "wz" "in" "et" "rp" "oo" "pr" "te" "ni" "zw" "mu" "xq" "cy" "vg" "bh" "gb" "yv" "qc" "ux" "wm" "iz" "en" "rt" "op" "po" "tr" "ne" "zi" "mw" "xu" "cq" "vy" "bg" "yb" "qv" "uc" "wx" "im" "ez" "rn" "ot" "pp" "to" "nr" "ze" "mi" "xw" "cu" "vq" "by" "qb" "uv" "wc" "ix" "em" "rz" "on" "pt" "tp" "no" "zr" "me" "xi" "cw" "vu" "bq" "ub" "wv" "ic" "ex" "rm" "oz" "pn" "tt" "np" "zo" "mr" "xe" "ci" "vw" "bu" "wb" "iv" "ec" "rx" "om" "pz" "tn" "nt" "zp" "mo" "xr" "ce" "vi" "bw" "ib" "ev" "rc" "ox" "pm" "tz" "nn" "zt" "mp" "xo" "cr" "ve" "bi" "eb" "rv" "oc" "px" "tm" "nz" "zn" "mt" "xp" "co" "vr" "be" "rb" "ov" "pc" "tx" "nm" "zz" "mn" "xt" "cp" "vo" "br" "ob" "pv" "tc" "nx" "zm" "mz" "xn" "ct" "vp" "bo" "pb" "tv" "nc" "zx" "mm" "xz" "cn" "vt" "bp" "tb" "nv" "zc" "mx" "xm" "cz" "vn" "bt" "nb" "zv" "mc" "xx" "cm" "vz" "bn" "zb" "mv" "xc" "cx" "vm" "bz" "mb" "xv" "cc" "vx" "bm" "xb" "cv" "vc" "bx" "cb" "vv" "bc" "vb" "bv" "bb")
                avy-style 'words
				;; avy-style 'de-bruijn
		  )
)

(use-package multiple-cursors :ensure t)

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode)
)

(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))


(provide 'atj-editor)
