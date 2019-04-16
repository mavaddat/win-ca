require! <[ assert node-forge ]>

export samples =
  total:  <[ ]>
  root:   <[ root ]>
  ca:     <[ ca ]>
  both:   <[ root ca ]>

counts = {}

# Final check
after !~>
  var first
  for k, v of counts
    checkCounts v
    if first
      assert.deepEqual v, first
    else
      first = v

# Build Checker if Buffer is valid X509 certificate (and count it)
export function assert509(mocha-test)
  suite = mocha-test .= test
  suite = while suite .= parent
    suite.title.slice 0 1
  suite .= reverse!join '' .toLowerCase!
  store = counts[suite] ||= {}
  store[variable = mocha-test.title] ||= 0

  !~>
    assert Buffer.is-buffer it
    tree = it
      .toString 'binary'
      |> nodeForge.asn1.fromDer
    assert tree.value.length, "Invalid certificate"

    assert ++store[variable] < 1000, "Too many certificates in store"

!function checkCounts
  for k, v of it
    assert v > 5, "Five certificates in store required"

  assert it.total == it.root
  assert it.root + it.ca == it.both

<-! process.on \exit
for , v of counts
  console.log \Total: v.total
  return
