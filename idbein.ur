sequence seq

table offers : { Id : int, Title : string, Threshold : int, VotesCount : int }
  PRIMARY KEY Id

table votes : { Id : int, OfferId : int }
  PRIMARY KEY Id
  CONSTRAINT C FOREIGN KEY OfferId REFERENCES offers(Id)
  ON DELETE RESTRICT

structure Style = struct
  style header style section1 style page
  style faq style content style screenLogo
  style newOffer style footer style copyright
  style offer style votes style title style info
  style divider style currentVotes style threshold
  style checkbox style miscInfo style author
  style about
end

fun layout yield = return <xml>
  <head>
    <link rel="stylesheet" type="text/css" href="/stylesheets/idbein.css"/>
  </head>

  <body>
    <div class={Style.header}>
      <ul class={Style.section1}>
        <li>All Offers</li>
      </ul>
    </div>

    <div class={Style.page}>
      <div class={Style.faq}>
        <h1>Are you in?</h1>
        <p>idbe.in (I'd be in) allows you to make offers.</p>
        <p>Any time people vote an offer of yours past its threshold,
           you're able to send them 1 message.</p>
      </div>
      <div class={Style.content}>
        {yield}
      </div>
    </div>

    <div class={Style.footer}>
      <div class={Style.copyright}>
        Copyright 2009 Larry Diehl, Zachary Berry &amp; Ian Turgeon
      </div>
    </div>

    <div class={Style.screenLogo}/>
  </body>
</xml>

structure Offer = struct
  fun list () = rows <- queryX (SELECT * FROM offers)
    (fn row => <xml><form><div class={Style.offer}>
      <div class={Style.votes}>
        <div class={Style.currentVotes}>{[row.Offers.VotesCount]}</div>
        <div class={Style.divider}>/</div>
        <div class={Style.threshold}>{[row.Offers.Threshold]}</div>
      </div>

      <hidden{#Id} value={show row.Offers.Id}/>
      <div class={Style.checkbox}>
        <submit action={vote} value="I'd be in"/>
      </div>

      <div class={Style.info}>
        <div class={Style.title}>{[row.Offers.Title]}</div>
      </div>
    </div></form></xml>);
  layout <xml>
    <a link={new ()} class={Style.newOffer}>+ make an offer</a>
    {rows}
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
