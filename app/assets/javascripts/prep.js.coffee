$ ->
  evaluateUserCode = (code) =>
    mocha.ui('bdd')
    mocha.suite.suites = []

    expect = chai.expect
    assert = chai.assert

    eval("var userFunc = " + code)

    describe "Addition", () =>
      it "should add two positive numbers", () =>
        expect(userFunc(1,2)).to.be.equal(3)

      it "should add two negative numbers", () =>
        expect(userFunc(-1,-2)).to.be.equal(-3)

    mocha.run()

  if($('#prep_test_editor').length > 0)
    testEditor = ace.edit("prep_test_editor");
    testEditor.setTheme("ace/theme/monokai");
    testEditor.getSession().setMode("ace/mode/javascript");

    $('.run-test').click (e) =>
      $('#mocha').html('')
      evaluateUserCode(testEditor.getValue())
