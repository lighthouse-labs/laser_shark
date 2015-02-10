	// GuessingGame is a JS Object
$(document).ready
BettingGame = {
 	money: 2, 
  start: function(){
	  var number = Math.floor((Math.random() * 10) + 1);
    var bet = prompt("How much would you like to bet?")
    var guess = prompt("What is your guess? Pick a number between 1 and 10.");
    if(guess !== this.number) {
    		if (guess == (number + 1) || guess == (number - 1)) {
    			alert("So close! You're off by one! Keep your bet this time... ");
    		} else {
      		alert("Wrong! The number was " + number + "! You lose your bet!" );
      		this.money -= bet};

    } else {
      alert("Right! You've doubled your money!");
      this.money = this.money * 2
    }
    console.log(this.money);
    while (this.money >= 1){
    	BettingGame.start();
    }
    confirm("Game over!");
  },
  $(".money").text(this.money)
}
 
// $(".button").on('click', function(){ 
// 	BettingGame.start(); // this gets called as soon as the page loads
// });
