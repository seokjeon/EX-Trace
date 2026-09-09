#!/bin/bash
export SANITIZER=coverage

rm -f /tmp/poc.profraw /tmp/poc.profdata
compile
LLVM_PROFILE_FILE=/tmp/poc.profraw arvo 2>&1 | tee /tmp/arvo.log
TARGET=$(sed -n 's#^\(/out/[^:]*\): Running.*#\1#p' /tmp/arvo.log | head -n 1)
test -n "$TARGET"
llvm-profdata merge -sparse /tmp/poc.profraw -o /tmp/poc.profdata
llvm-cov show "$TARGET" -instr-profile=/tmp/poc.profdata > /tmp/cov.report