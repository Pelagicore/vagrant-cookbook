#!/bin/bash
# vagrant-cookbook
# Copyright (C) 2015 Pelagicore AB
#
# Permission to use, copy, modify, and/or distribute this software for
# any purpose with or without fee is hereby granted, provided that the
# above copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR
# BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES
# OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
# WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
# ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
# SOFTWARE.
#
# For further information see LICENSE
#
#
# Usage: clang-code-analysis.sh <sourcedir> <clangdir> <cmake_args>
#
# Where <sourcedir> is the directory where the sources reside. <clangdir>
# is the dirname created inside <sourcedir> to run the clang analysis.
#
# The <clangdir> will be deleted before running the analysis.
#

CHECKERS="-enable-checker alpha.core.BoolAssignment\
    -enable-checker alpha.core.CallAndMessageUnInitRefArg\
    -enable-checker alpha.core.CastSize\
    -enable-checker alpha.core.CastToStruct\
    -enable-checker alpha.core.FixedAddr\
    -enable-checker alpha.core.IdenticalExpr\
    -enable-checker alpha.core.PointerArithm\
    -enable-checker alpha.core.PointerSub\
    -enable-checker alpha.core.SizeofPtr\
    -enable-checker alpha.core.TestAfterDivZero\
    -enable-checker alpha.cplusplus.VirtualCall\
    -enable-checker alpha.deadcode.UnreachableCode\
    -enable-checker alpha.osx.cocoa.Dealloc\
    -enable-checker alpha.osx.cocoa.DirectIvarAssignment\
    -enable-checker alpha.osx.cocoa.DirectIvarAssignmentForAnnotatedFunctions\
    -enable-checker alpha.osx.cocoa.InstanceVariableInvalidation\
    -enable-checker alpha.osx.cocoa.MissingInvalidationMethod\
    -enable-checker alpha.security.ArrayBound\
    -enable-checker alpha.security.ArrayBoundV2\
    -enable-checker alpha.security.MallocOverflow\
    -enable-checker alpha.security.ReturnPtrRange\
    -enable-checker alpha.security.taint.TaintPropagation\
    -enable-checker alpha.unix.Chroot\
    -enable-checker alpha.unix.PthreadLock\
    -enable-checker alpha.unix.SimpleStream\
    -enable-checker alpha.unix.Stream\
    -enable-checker alpha.unix.cstring.BufferOverlap\
    -enable-checker alpha.unix.cstring.NotNullTerminated\
    -enable-checker alpha.unix.cstring.OutOfBounds\
    -enable-checker core.CallAndMessage\
    -enable-checker core.DivideZero\
    -enable-checker core.DynamicTypePropagation\
    -enable-checker core.NonNullParamChecker\
    -enable-checker core.NullDereference\
    -enable-checker core.StackAddressEscape\
    -enable-checker core.UndefinedBinaryOperatorResult\
    -enable-checker core.VLASize\
    -enable-checker core.builtin.BuiltinFunctions\
    -enable-checker core.builtin.NoReturnFunctions\
    -enable-checker core.uninitialized.ArraySubscript\
    -enable-checker core.uninitialized.Assign\
    -enable-checker core.uninitialized.Branch\
    -enable-checker core.uninitialized.CapturedBlockVariable\
    -enable-checker core.uninitialized.UndefReturn\
    -enable-checker cplusplus.NewDelete\
    -enable-checker deadcode.DeadStores\
    -enable-checker llvm.Conventions\
    -enable-checker osx.API\
    -enable-checker osx.SecKeychainAPI\
    -enable-checker osx.cocoa.AtSync\
    -enable-checker osx.cocoa.ClassRelease\
    -enable-checker osx.cocoa.IncompatibleMethodTypes\
    -enable-checker osx.cocoa.Loops\
    -enable-checker osx.cocoa.MissingSuperCall\
    -enable-checker osx.cocoa.NSAutoreleasePool\
    -enable-checker osx.cocoa.NSError\
    -enable-checker osx.cocoa.NilArg\
    -enable-checker osx.cocoa.NonNilReturnValue\
    -enable-checker osx.cocoa.RetainCount\
    -enable-checker osx.cocoa.SelfInit\
    -enable-checker osx.cocoa.UnusedIvars\
    -enable-checker osx.cocoa.VariadicMethodTypes\
    -enable-checker osx.coreFoundation.CFError\
    -enable-checker osx.coreFoundation.CFNumber\
    -enable-checker osx.coreFoundation.CFRetainRelease\
    -enable-checker osx.coreFoundation.containers.OutOfBounds\
    -enable-checker osx.coreFoundation.containers.PointerSizedValues\
    -enable-checker security.FloatLoopCounter\
    -enable-checker security.insecureAPI.UncheckedReturn\
    -enable-checker security.insecureAPI.getpw\
    -enable-checker security.insecureAPI.gets\
    -enable-checker security.insecureAPI.mkstemp\
    -enable-checker security.insecureAPI.mktemp\
    -enable-checker security.insecureAPI.rand\
    -enable-checker security.insecureAPI.strcpy\
    -enable-checker security.insecureAPI.vfork\
    -enable-checker unix.API\
    -enable-checker unix.Malloc\
    -enable-checker unix.MallocSizeof\
    -enable-checker unix.MismatchedDeallocator\
    -enable-checker unix.cstring.BadSizeArg\
    -enable-checker unix.cstring.NullArg"

sourcedir=$1
clangdir=$2
cmakeargs=$3

sudo apt-get install -y clang valgrind

# Remove old dir if existing
rm -rf $sourcedir/$clangdir
mkdir -p $sourcedir/$clangdir
cd $sourcedir/$clangdir

scandir="scan_build_output"

# CMake
scan-build $CHECKERS -o "$scandir" cmake ../ $cmakeargs
rm -rf "$scandir/*"

# Build
scan-build $CHECKERS -o "$scandir" make
cd $scandir
rename -f 's/.*/report/' *
