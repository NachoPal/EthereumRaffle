var Raffle = artifacts.require("./Raffles.sol");

contract('Raffle', function() {

  let raffle;
  var expectedPrice = 10;
  var expectedLifespan = 120;

  beforeEach('setup contract for each test', async function () {
    raffle = await Raffle.deployed();

    await raffle.registerPlayer('Nacho');
    await raffle.create(expectedPrice, expectedLifespan);
  });

  it("Should create a Raffle", async function() {
    //await raffle.create.call(expectedPrice, expectedLifespan);
    let head = await raffle.head();

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
      ], "Didn't create the Raffle properly"
    )



  });
})