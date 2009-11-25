sequence seq

table offers : { Id : int, Title : string, Threshold : int, VotesCount : int }
  PRIMARY KEY Id

table votes : { Id : int, OfferId : int }
  PRIMARY KEY Id
  CONSTRAINT C FOREIGN KEY OfferId REFERENCES offers(Id)
  ON DELETE RESTRICT

style header style section1 style page
style faq style content style screenLogo
style newOffer style footer style copyright

fun layout yield = return <xml>
  <head>
    <link rel="stylesheet" type="text/css" href="/stylesheets/idbein.css"/>
  </head>

  <body>
    <div class={header}>
      <ul class={section1}>
        <li>All Offers</li>
      </ul>
    </div>

    <div class={page}>
      <div class={faq}>
        <h1>Are you in?</h1>
        <p>idbe.in (I'd be in) allows you to make offers.</p>
        <p>Any time people vote an offer of yours past its threshold,
           you're able to send them 1 message.</p>
      </div>
      <div class={content}>
        {yield}
      </div>
    </div>

    <div class={footer}>
      <div class={copyright}>
        Copyright 2009 Larry Diehl, Zachary Berry &amp; Ian Turgeon
      </div>
    </div>

    <div class={screenLogo}/>
  </body>
</xml>

structure Offer = struct
  fun list () = rows <- queryX (SELECT * FROM offers)
    (fn row => <xml><tr>
      <form>
        <hidden{#Id} value={show row.Offers.Id}/>
        <td>
          <submit action={vote} value="I'd be in"/>
          {[row.Offers.VotesCount]}/{[row.Offers.Threshold]}
        </td>
        <td>{[row.Offers.Title]}</td>
      </form>
    </tr></xml>);
  layout <xml>
    <a link={new ()} class={newOffer}>+ make an offer</a>

    <table border=1>
      <tr> <th/> <th>Title</th> </tr>
      {rows}
    </table>
  </xml>

  and new () = layout <xml>
    <table>
      <form>
        <tr> <th>Title:</th> <td><textbox{#Title}/> e.g. Intro to theorem proving</td> </tr>
        <tr> <th>Threshold:</th> <td><textbox{#Threshold}/> e.g. 15</td> </tr>
        <tr> <th/> <td><submit action={create} value="Offer this"/></td> </tr>
      </form>
    </table>
  </xml>

  and create offer =
    id <- nextval seq;
    dml (INSERT INTO offers (Id, Title, Threshold, VotesCount)
         VALUES ({[id]}, {[offer.Title]}, {[readError offer.Threshold]}, {[0]}));
    list ()

  and vote offer =
    id <- nextval seq;
    dml (INSERT INTO votes (Id, OfferId)
         VALUES ({[id]}, {[readError offer.Id]}));
    votesCount <- oneRowE1 (SELECT offers.VotesCount AS VC FROM offers
                            WHERE offers.Id = {[readError offer.Id]});
    dml (UPDATE offers SET VotesCount = {[votesCount + 1]}
         WHERE Id = {[readError offer.Id]});
    list ()
end

fun index () = Offer.list ()
