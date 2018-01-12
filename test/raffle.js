var Raffle = artifacts.require("./Raffles.sol");

contract('Raffle', function() {

  let raffle;
  let head;
  var expectedPrice = 10000000000000000;
  var expectedLifespan = 120;
  var accountIndex = 0;

  beforeEach('setup contract for each test', async function () {
    raffle = await Raffle.deployed();

    await raffle.registerPlayer('Nacho',{from: web3.eth.accounts[accountIndex]});
    await raffle.create(expectedPrice, expectedLifespan);

    head = await raffle.head();

    accountIndex = accountIndex + 1;
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
    await raffle.play(head,{value: expectedPrice, from: web3.eth.accounts[0]});

    let player = await raffle.ownerByTicket(head, 1);
    assert.equal(player, web3.eth.accounts[0], 'Player did not participate in the raffle');

    let ticket = await raffle.ticketsByOwner(head, player);
    assert.equal(ticket, 1, 'Player did not buy the correct ticket number');
  });


})