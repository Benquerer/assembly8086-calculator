function raizQuadrada(num,deci){
	let arrayBidimen = []
	//constroi o array bidimensional 
	num = num*100**(deci*2)
	console.log(num)
	while(num!=0){
		arrayBidimen.push(num%100);
		//console.log(num%100)
		num=Math. trunc(num/100); 
	}

	//inverte o arary
	arrayBidimen.reverse()
	console.log(arrayBidimen)
	//inicializa o (actual) a zero
	let r = 0;
	//inicializa o resultado a zero
	let result =0;
	let holder = 0
	var h =0
	for(let k=0;k<arrayBidimen.length;k++ ){
		holder = 0;
		r*=100;
		r +=arrayBidimen[k]
		
		result *=10 
		for(var i = 0;i<10;i++){
			if((result*2 + i) * i <=  r){
				holder = i;
				//**********Tests******//
				console.log("\tholder"+holder)
			}
			//**********Tests******//
			//console.log("\t"+i+" "+((result*2 + i) * i<=r))
		}
		
		r-=(result*2 + holder) * holder
		result=result + holder;
		//********Tests******//
		//console.log("r "+r)
		console.log("result "+result)
	}
	return result/(100**deci);
	
}
console.log(raizQuadrada(400,2));
console.log(raizQuadrada(164,2));
//console.log(raizQuadrada(5,4));