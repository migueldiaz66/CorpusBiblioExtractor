# Thin wrapper over make.R (the cross-platform runner). Windows users without
# `make` can call `Rscript make.R <target>` directly.
RSCRIPT ?= Rscript

.PHONY: setup test check run extract index help

help:    ; @$(RSCRIPT) make.R help
setup:   ; $(RSCRIPT) make.R setup
test:    ; $(RSCRIPT) make.R test $(ARGS)
check:   ; $(RSCRIPT) make.R check
run:     ; $(RSCRIPT) make.R run $(BIB)
extract: ; $(RSCRIPT) make.R extract
index:   ; $(RSCRIPT) make.R index $(RUN)
