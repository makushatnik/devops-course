// Fast String Concatenation.
// https://habr.com/ru/post/417479/.

package main

import ("unsafe")

type stringStruct struct {
  str *byte
  len int
}

func concat(x, y string) string {
  length := len(x) + len(y)
  if length == 0 {
    return ""
  }
  b := make([]byte, length)
  copy(b, x)
  copy(b[len(x):], y)
  return goString(&b[0], length)
}

func goString(ptr *byte, length int) string {
  s := stringStruct{str: ptr, len: length}
  return *(*string)(unsafe.Pointer(&s))
}
