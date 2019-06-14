var BettingApp = {
/*-----------------------------------------------------------
	Variables
-----------------------------------------------------------*/
	// Constants
	animSpeed: 				"fast",
	voucherID_step: 		1,
	voucherID_target: 		"#voucherIDView",
	noCredits_step: 		2,
	noCredits_target:		"#noCreditsView",
	chooseBetType_step:		3,
	chooseBetType_target:	"#chooseBetTypeView",
	agencyBet_step:			4.1,
	agencyBet_target:		"#agencyBetView",
	playerBet_step:			4.2,
	playerBet_target:		"#playerBetView",
	confirmation_step:		5,
	confirmation_target:	"#confirmationView",
	
	// Steps
	step:					0,
	
	// VoucherID
	voucherIDDefaultText:	"",



	
	
/*-----------------------------------------------------------
	Initialize
-----------------------------------------------------------*/
	init:function()
	{	
		// Scroll to top for fullscreen
		BettingApp.hideAddressBar();
		
		// Initialize each section
		BettingApp.voucherID_init();
		BettingApp.noCredits_init();
		BettingApp.chooseBetType_init();
		BettingApp.agencyBet_init();
		BettingApp.playerBet_init();
		BettingApp.confirmation_init();
		
		// Hide initial Views
		//$(BettingApp.getStepView(BettingApp.voucherID_step)).slideUp(0);
		$(BettingApp.voucherID_target).slideUp(0);
		$(BettingApp.noCredits_target).slideUp(0);
		$(BettingApp.chooseBetType_target).slideUp(0);
		$(BettingApp.agencyBet_target).slideUp(0);
		$(BettingApp.playerBet_target).slideUp(0);
		$(BettingApp.confirmation_target).slideUp(0);
		
		// Show Step 1
		BettingApp.updateStep(BettingApp.voucherID_step);
	},



	
	
/*-----------------------------------------------------------
	Hide Address Bar
-----------------------------------------------------------*/
	hideAddressBar:function()
	{
		//window.scrollTo(0,1);
	},


	
	
/*-----------------------------------------------------------
	Background
-----------------------------------------------------------*/
	resize:function()
	{
		
	},

	
	
/*-----------------------------------------------------------
	Navigation
-----------------------------------------------------------*/
	updateStep:function(value)
	{
		//console.log("updateStep( " + value + " )");
	
		var prevStep = BettingApp.step;
		//console.log("... prevStep: " + prevStep);
		
		BettingApp.step = value;
		
		switch(BettingApp.step)
		{
			default: break;
			
			case BettingApp.playerBet_step:
			case BettingApp.agencyBet_step:
				BettingApp.loadData();
				break;
		}
		
		// Current
		//console.log("updateStep() sliding");
		$(BettingApp.getStepView(BettingApp.step)).slideDown(BettingApp.animSpeed, "linear", BettingApp.hideAddressBar);
		//console.log("updateStep() slid");
		
		// Prev
		if(prevStep > 0 && prevStep != BettingApp.step)
		{
			//console.log("updateStep() new step found");
			$(BettingApp.getStepView(prevStep)).slideUp(BettingApp.animSpeed, "linear");
		}
		
		//console.log("updateStep() finished");
	},
	
	getStepView:function(value)
	{
		//console.log("getStepView( " + value + " )");
		
		switch(value)
		{
			case BettingApp.voucherID_step:
				return BettingApp.voucherID_target;
				
			case BettingApp.noCredits_step:
				return BettingApp.noCredits_target;
				
			case BettingApp.chooseBetType_step:
				return BettingApp.chooseBetType_target;
				
			case BettingApp.agencyBet_step:
				return BettingApp.agencyBet_target;
				
			case BettingApp.playerBet_step:
				return BettingApp.playerBet_target;
				
			case BettingApp.confirmation_step:
				return BettingApp.confirmation_target;
				
			default:
				return ""; 
				break;	
		}
	},
	
	reset:function()
	{
		BettingApp.updateStep(1);
	},
	

	
	
/*-----------------------------------------------------------
	Data loading & handling
-----------------------------------------------------------*/
	loadData:function()
	{
		// TODO Load json from server
		console.log("loadData()");
		
		BettingApp.resetData();
		$.getJSON("/_res/json/sampleData.json")
		.done(BettingApp.parseData)
		.fail(BettingApp.loadDataError);
	},
	
	loadDataError:function()
	{
		console.log("loadDataError()");
		
	},
	
	parseData:function(data)
	{
		console.log("parseData()");
		
		var players = [];
		
		// Agencies
		for( var i = 0 ; i < data.length ; i++ )
		{
			//console.log();
			//console.log(data[i]);
			var agency = data[i];
			$("#agencyListItemTemplate").tmpl(agency).appendTo("#agencyBetView ul");
			
			for(var ii = 0 ; ii < agency.players.length ; ii++)
			{
				players.push(agency.players[ii]);
			}
		}
		
		// Players
		players.sort(function(a, b)
		{
    		var a1= a.name, b1= b.name;
    		if(a1== b1) return 0;
    		return a1 > b1? 1: -1;
		});
		
		for( var iii = 0 ; iii < players.length ; iii++ )
		{
			$("#playerListItemTemplate").tmpl(players[iii]).appendTo("#playerBetView ul");
		}
		/*
		function(data) {
			$("#employerList").tmpl(data).appendTo("#ajax-target");
		});
		*/
		
		BettingApp.activateData();
	},
	
	resetData:function()
	{
		console.log("resetData()");
		var self = this;
		$("#agencyBetView ul li").remove();
		$("#playerBetView ul li").remove();
	},
	
	activateData:function()
	{
		console.log("activateData()");
		var self = this;
		// Agency
		$("#agencyBetView ul li").each(function(index){
			$(this).click(function(event){
				event.preventDefault();
				if (confirm('Are you sure you want to place a bet on ' + $(event.target).data("name") + "?"))
				{
					BettingApp.updateStep(BettingApp.confirmation_step);
				}
			});
		});
		
		// Players
		$("#playerBetView ul li").each(function(index){
			$(this).click(function(event)
			{
				event.preventDefault();
				if (confirm('Are you sure you want to place a bet on ' + $(event.target).data("name") + "?"))
				{
					BettingApp.updateStep(BettingApp.confirmation_step);
				}
			});
		});
	},

	
	
/*-----------------------------------------------------------
	Inputs
-----------------------------------------------------------*/
	clearSearchOnFocus:function(target)
	{
		if($(target).val() == "Search")
		{
			$(target).val("");
		};
	},
	
	restoreSearchOnFocusOut:function(target)
	{
		if($(target).val() == "")
		{
			$(target).val("Search");
		};	
	},
	
	filterList:function(targetItems, filterValue, dataAttr)
	{
		//console.log("filterList( " + targetItems + ", " + filterValue + ")" );
			
		var processFilter = filterValue != "" && filterValue != "Search";
		var showOrHide = true;
		
		$(targetItems).each(function(index)
		{
			// console.log($(this).text());
			
			if(processFilter)
			{
				showOrHide = $(this).data(dataAttr).toLowerCase().lastIndexOf(filterValue.toLowerCase()) > -1;
			}
	
			if(showOrHide)
			{
				//$(targetItems)[index].slideDown("fast");
				$(this).slideDown("fast");
			}
			else
			{
				//$(targetItems)[index].slideUp("fast");
				$(this).slideUp("fast");
			}
		});
	},
	
	
	
/*-----------------------------------------------------------
	Step 1 - VoucherID
-----------------------------------------------------------*/
	voucherID_init:function()
	{
		// Set default text for clearing
		BettingApp.voucherIDDefaultText = $("#voucherIDView .header .result").html();
		
		// Add Next button in voucherID
		$("#voucherIDView .numPad").click( function(event) { event.preventDefault(); BettingApp.voucherID_numPad( $(event.target).html() ); });
		
		$("#voucherIDView .clearButton").click( function(event) { event.preventDefault(); BettingApp.voucherID_clear(); });
		
		$("#voucherIDView .enterButton").click( function(event) { event.preventDefault(); BettingApp.voucherID_enter(); });
	},
	
	voucherID_numPad:function(value)
	{
		console.log("voucherID_numPad(" + value + ")");
		var curValue = $("#voucherIDView .header .result").html();
		var newValue = BettingApp.voucherIDDefaultText == curValue ? value : curValue + value;
		$("#voucherIDView .header .result").html(newValue);
	},
	
	voucherID_enter:function()
	{
		var curValue = $("#voucherIDView .header .result").html();
		
		if(curValue == this.voucherIDDefaultText || curValue.length != 4)
		{
			alert("Please fill in a valid Voucher ID");
		} else {
			BettingApp.noCredits_check();
		}
	},
	
	voucherID_clear:function()
	{
		$("#voucherIDView .header .result").html(BettingApp.voucherIDDefaultText);
	},
	
	
	
/*-----------------------------------------------------------
	Step 2 - No credits
-----------------------------------------------------------*/
	noCredits_init:function()
	{
		// Add Next button in voicherID
		$("#noCreditsView .cancel").click( function(event) { event.preventDefault(); BettingApp.updateStep(BettingApp.chooseBetType_step) });
	},
	
	noCredits_check:function()
	{
		var hasCredits = false;
		
		if(hasCredits)
		{
			BettingApp.updateStep(BettingApp.chooseBetType_step);
		} else {
			BettingApp.updateStep(BettingApp.noCredits_step);
		}
	},
	
	
	
/*-----------------------------------------------------------
	Step 3 - Choose Bet Type
-----------------------------------------------------------*/
	chooseBetType_init:function()
	{
		$("#chooseBetTypeView .cancel").click( BettingApp.chooseBetType_cancel );
		
		$("#chooseBetTypeView .button.agency").click( BettingApp.chooseBetType_agency );
		
		$("#chooseBetTypeView .button.player").click( BettingApp.chooseBetType_player );
	},
	
	chooseBetType_agency:function()
	{
		BettingApp.updateStep(BettingApp.agencyBet_step);
	},
	
	chooseBetType_player:function()
	{
		BettingApp.updateStep(BettingApp.playerBet_step);
	},
	
	chooseBetType_cancel:function()
	{
		BettingApp.updateStep(BettingApp.voucherID_step);
	},
	
	
/*-----------------------------------------------------------
	Step 4.1 - Bet on Agency
-----------------------------------------------------------*/
	agencyBet_init:function()
	{
		$("#agencyBetView .cancel").click( function(event)
		{
			event.preventDefault();
			BettingApp.agencyBet_cancel();
		});
		
		$("#agencyBetView .search").bind(
			"propertychange keyup input paste",
			function(event)
			{
				BettingApp.filterList($("#agencyBetView ul li"), $(event.target).val(), "name");
			}
		);
		
		$("#agencyBetView .search").focus( function(event){ BettingApp.clearSearchOnFocus(event.target); });
		
		$("#agencyBetView .search").focusout( function(event){ BettingApp.restoreSearchOnFocusOut(event.target); });
	},
	
	agencyBet_load:function()
	{
		
	},
	
	agencyBet_cancel:function()
	{
		BettingApp.updateStep(BettingApp.voucherID_step);
	},
	
	
/*-----------------------------------------------------------
	Step 4.2 - Bet on Player
-----------------------------------------------------------*/
	playerBet_init:function()
	{
		$("#playerBetView .cancel").click( function(event)
		{
			event.preventDefault();
			BettingApp.playerBet_cancel();
		});
		
		$("#playerBetView .search").bind(
			"propertychange keyup input paste",
			function(event)
			{
				BettingApp.filterList($("#playerBetView ul li"), $(event.target).val(), "name");
			}
		);
		
		$("#playerBetView .search").focus( function(event){ BettingApp.clearSearchOnFocus(event.target); });
		
		$("#playerBetView .search").focusout( function(event){ BettingApp.restoreSearchOnFocusOut(event.target); });
	},
	
	playerBet_cancel:function()
	{
		BettingApp.updateStep(BettingApp.voucherID_step);
	},



/*-----------------------------------------------------------
	Step 5 - Confirmation
-----------------------------------------------------------*/
	confirmation_init:function()
	{
		$("#confirmationView .cancel").click(function(event)
		{ 
			event.preventDefault();
			BettingApp.updateStep(BettingApp.voucherID_step);
		});
	}
		
};

//BettingApp.loadData();

$(document).ready(function(){ BettingApp.init(); });