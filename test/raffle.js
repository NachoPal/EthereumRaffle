var Raffle = artifacts.require("./Raffles.sol");

contract('Raffle', function(accounts) {

  // const increaseTime = addSeconds => {
  //   web3.currentProvider.send({
  //     jsonrpc: "2.0",
  //     method: "evm_increaseTime",
  //     params: [addSeconds], id: 0
  //   })
  // }
  //

  const timeTravel = function (time) {
    return new Promise((resolve, reject) => {
        web3.currentProvider.sendAsync({
        jsonrpc: "2.0",
        method: "evm_increaseTime",
        params: [time], // 86400 is num seconds in day
        id: new Date()
      }, (err, result) => {
        if(err){ return reject(err) }
        return resolve(result)
      });
    });
  };
  //
  const mineBlock = function () {
    return new Promise((resolve, reject) => {
        web3.currentProvider.sendAsync({
        jsonrpc: "2.0",
        method: "evm_mine"
      }, (err, result) => {
        if(err){ return reject(err) }
        return resolve(result)
      });
    })
  };


  let raffle;
  let head;
  var expectedPrice = 10000000000000000;
  var expectedLifespan = 120;

  beforeEach('Create players and a raffle for each test', async function () {

    raffle = await Raffle.deployed();
    await raffle.registerPlayer('Nacho');
    await raffle.registerPlayer('Pepe', {from: accounts[1]});

    await raffle.create(expectedPrice, expectedLifespan);

    head = await raffle.head();
  });

  afterEach('Delete a player after each tests', async function() {
    await raffle.destroyPlayer(accounts[0]);
    await raffle.destroyPlayer(accounts[1], {from: accounts[1]});
  });

  it("Create a Raffle", async function() {

    let raffles = await raffle.raffles(head);

    [
      id,
      next,
      exists,
      finished,
      price,
      startsAt,
      endsAt,
      lastTicketNumber,
      winnerticket,
      winnerPlayer
    ] = raffles;


    assert.deepEqual(
      [
        id,
        next,
        exists,
        finished,
        price.toNumber(),
        endsAt.toNumber() - startsAt.toNumber(),
        lastTicketNumber.toNumber(),
        winnerticket.toNumber(),
        winnerPlayer
      ],
      [
        head,
        '0x0000000000000000000000000000000000000000000000000000000000000000',
        true,
        false,
        expectedPrice,
        expectedLifespan,
        0,
        0,
        '0x0000000000000000000000000000000000000000'
      ], "It didn't create a Raffle properly"
    )
  });

  it("A Player participate in the raffle", async function() {
    await raffle.play(head,{value: expectedPrice, from: accounts[0]});

    let player = await raffle.ownerByTicket(head, 1);
    assert.equal(player, accounts[0], 'Player did not participate in the raffle');

    let ticket = await raffle.ticketsByOwner(head, player);
    assert.equal(ticket, 1, 'Player did not buy the correct ticket number');
  });

  it("A raffle finished and the winner withdraw the prize", async function() {
    await raffle.play(head,{value: expectedPrice, from: accounts[0]});
    await raffle.play(head,{value: expectedPrice, from: accounts[1]});
    await raffle.play(head,{value: expectedPrice, from: accounts[1]});
    await raffle.play(head,{value: expectedPrice, from: accounts[0]});

    let expectedLastTicketNumber = 4;

    await timeTravel(300);
    await mineBlock();
    await raffle.getWinner(head);

    let raffles = await raffle.raffles(head);

    [
      id,
      next,
      exists,
      finished,
      price,
      startsAt,
      endsAt,
      lastTicketNumber,
      winnerticket,
      winnerPlayer
    ] = raffles;

    let expectedWinnerPlayer = await raffle.ownerByTicket(head, winnerticket);
    [index, exists, name, pendingWithdrawals] = await raffle.players(winnerPlayer);

    let expectedPendingWithdrawals = expectedLastTicketNumber * expectedPrice;

    assert.equal(lastTicketNumber, expectedLastTicketNumber, 'Tickets were not assigned properly');
    assert.equal(winnerPlayer, expectedWinnerPlayer, 'Winner player was not choose properly');
    assert.equal(pendingWithdrawals.toNumber(), expectedPendingWithdrawals, 'Winner player did not receive the prize properly');

    let initialWinnerBalance = web3.eth.getBalance(winnerPlayer);

    let response = await raffle.playerWithdraw(expectedPendingWithdrawals, {from: winnerPlayer});

    let txHash = response.tx;

    let tx = web3.eth.getTransaction(txHash);
    let gasPrice = tx.gasPrice;

    let txReceipt = web3.eth.getTransactionReceipt(txHash);
    let gasUsed = txReceipt.gasUsed;

    let txCost = gasPrice * gasUsed;

    let finalWinnerBalance = web3.eth.getBalance(winnerPlayer);

    let expectedFinalWinnerBalance = initialWinnerBalance.toNumber() +
                                     expectedPendingWithdrawals - txCost;

    assert.equal(finalWinnerBalance.toNumber(), expectedFinalWinnerBalance, 'Winner player did not withdraw the prize properly');

  });


})