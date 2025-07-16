class LookingEyes {
	
	/**
	* Draw looing eye balls on top left and top right of canvas 2x2 grid.
	* [- -]
	* [   ]
	* with three postions, left, center and right
	*/
	constructor(face) {
		
		this.face = face;
		
		this.canvas = this.face.canvas;
		
		this.width = this.canvas.width / 4;
		this.height = this.canvas.height / 4;
		
		this.leftX = this.canvas.width / 6;
		this.leftY = this.canvas.height / 5;
		
		this.rightX = this.canvas.width - this.width - this.leftX;
		this.rightY = this.canvas.height / 5;
		
		this.leftBallX = this.leftX + this.width / 2;
		this.leftBallY =  this.leftY + this.height + 25;
		
		this.rightBallX = this.rightX + this.width / 2;
		this.rightBallY = this.rightY + this.height + 25;
		
		this.direction = -1;
		this.offset = 10;
				
	}
	
	update() {
		
		if (this.direction<0) {
			if (this.leftBallX<this.leftX) {
				this.direction = 1;
			}
		}
		
		if (this.direction>0) {
			if (this.leftBallX>this.leftX + this.width) {
				this.direction = -1;
			}
		}
		
		this.leftBallX += this.offset * this.direction;
		this.rightBallX += this.offset * this.direction;
		
	}
	
	draw() {
		
		let ctx = this.canvas.getContext("2d");
		ctx.lineWidth = 20;
		ctx.strokeStyle = "black";
		ctx.fillStyle = "black";
		
		ctx.beginPath();
		ctx.moveTo(this.leftX, this.leftY + this.height);
		ctx.lineTo(this.leftX + this.width, this.leftY + this.height);
		ctx.stroke();
		ctx.closePath();
		
		ctx.beginPath();
		ctx.moveTo(this.rightX, this.rightY + this.height);
		ctx.lineTo(this.rightX + this.width, this.rightY + this.height);
		ctx.stroke();
		ctx.closePath();
		
		ctx.beginPath();
		ctx.ellipse(this.leftBallX, this.leftBallY, 25, 25, 0, 0, 2 * Math.PI);
		ctx.fill();			
		
		ctx.beginPath();
		ctx.ellipse(this.rightBallX, this.rightBallY, 25, 25, 0, 0, 2 * Math.PI);
		ctx.fill();	
		
	}
	
}

class HappyEyes {
	
	/**
	* Draw happy eyes on top left and top right of canvas 2x2 grid.
	* [^ ^]
	* [   ]
	*/
	constructor(face) {
		
		this.face = face;
		this.canvas = face.canvas;
		
		this.width = this.canvas.width / 4;
		this.height = this.canvas.height / 8;
		
		this.leftX = this.canvas.width / 6;
		this.leftY = this.canvas.height / 5 + this.height;
		
		this.rightX = this.canvas.width - this.width - this.leftX;
		this.rightY = this.canvas.height / 5 + this.height;
		
		this.top = this.leftY;
		this.bottom = this.leftY + this.height / 5;
		
		this.direction = -1;
		this.offset = 10;
		
	}
	
	update() {
		
		if (this.direction<0) {
			if (this.leftY<this.top) {
				this.direction = 1;
			}
		}
		
		if (this.direction>0) {
			if (this.leftY>this.bottom) {
				this.direction = -1;
			}
		}
		
		this.leftY += this.offset * this.direction;
		this.rightY += this.offset * this.direction;
		
	}	
	
	draw() {
		
		let ctx = this.canvas.getContext("2d");
		ctx.lineWidth = 20;
		ctx.strokeStyle = "black";
		
		ctx.beginPath();
		ctx.moveTo(this.leftX, this.leftY + this.height);
		ctx.lineTo(this.leftX + this.width / 2, this.leftY);
		ctx.lineTo(this.leftX + this.width, this.leftY + this.height);
		ctx.stroke();
		ctx.closePath();
		
		ctx.beginPath();
		ctx.moveTo(this.rightX, this.rightY + this.height);
		ctx.lineTo(this.rightX + this.width / 2, this.rightY);
		ctx.lineTo(this.rightX + this.width, this.rightY + this.height);
		ctx.stroke();
		ctx.closePath();
		
	}
}

class Mouth {
	
	constructor(face) {
		
		this.canvas = face.canvas;
		
		this.width = this.canvas.width / 6;
		
		this.x = this.canvas.width / 2 - this.canvas.width / 12;
		this.y = this.canvas.height - this.canvas.height / 4;
		
		this.height = 50;
	}
	
	update() {
			
	}
	
	draw() {
		
		let ctx = this.canvas.getContext("2d");
		ctx.lineWidth = 20;
		ctx.strokeStyle = "#F67280";
		ctx.fillStyle = "#F67280";
		
		ctx.beginPath();
		ctx.moveTo(this.x, this.y);
		ctx.lineTo(this.x + this.width, this.y);
		ctx.stroke();
		ctx.closePath();			
				
	}

}

class SpeakingMouth {
	
	constructor(face) {
		
		this.canvas = face.canvas;
		
		this.width = this.canvas.width / 6;
		
		this.x = this.canvas.width / 2 - this.canvas.width / 12;
		this.y = this.canvas.height - this.canvas.height / 4;
		
		this.height = 50;
		this.maxHeight = this.canvas.height / 20;
		
		this.direction = 1;
		this.offset = 20;
	}
	
	update() {
		
		if (this.direction<0) {
			if (this.height<20) {
				this.direction = 1;
			}
		}
		
		if (this.direction>0) {
			if (this.height>this.maxHeight) {
				this.direction = -1;
			}
		}
		
		this.height += this.offset * this.direction;
		
	}
	
	draw() {
		
		let ctx = this.canvas.getContext("2d");
		ctx.lineWidth = 20;
		ctx.strokeStyle = "#F67280";
		ctx.fillStyle = "#F67280";
		
		ctx.beginPath();
		ctx.moveTo(this.x, this.y);
		ctx.lineTo(this.x + this.width, this.y);
		ctx.stroke();
		ctx.closePath();			
		
		ctx.fillRect(this.x, this.y, this.width, this.height);
		
	}	
	
}

class Face {
	
	constructor(canvas) {		
		this.canvas = canvas;		
	}
	
	standby() {
		this.eyes = new LookingEyes(this);		
		this.mouth = new Mouth(this);
	}
	
	happy() {
		this.eyes = new HappyEyes(this);		
		this.mouth = new SpeakingMouth(this);
	}
	
	update() {
		this.eyes.update();
		this.mouth.update();
	}
	
	draw() {
		this.eyes.draw();
		this.mouth.draw();
	}
}

class Robo {
	
	constructor(canvas, skinColor) {
		
		if (!canvas) {
			this.canvas = document.createElement("canvas");
			this.canvas.width  = window.innerWidth;
			this.canvas.height = window.innerHeight;			
		} else {
			this.canvas = canvas;
		}
		
		document.body.style.marginTop = "0px";
		document.body.style.marginLeft = "0px";
		document.body.style.overflow = "hidden";
		
		document.body.appendChild(this.canvas);
								
		if (!skinColor) {
			skinColor = "#F8B195"
		}
		this.skinColor = skinColor;
		
		this.face = new Face(this.canvas);
		this.face.standby();
	}
	
	start() {
		
		let robo = this;
		
		setInterval(function() {
	
			robo.update();
			robo.draw();
	
		}, 250);
		
	}
	
	speak() {
		
		this.face.happy();
		
		let robo = this;
		
		setTimeout(function() {
			
			robo.standby();
			
		}, 5000);//Max speak
	}
	
	standby() {
		this.face.standby();
	}
	
	update() {		
		this.face.update();		
	}
	
	draw() {
		
		let ctx = this.canvas.getContext("2d");
		ctx.fillStyle = this.skinColor;
		ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
		
		this.face.draw();
	}
}