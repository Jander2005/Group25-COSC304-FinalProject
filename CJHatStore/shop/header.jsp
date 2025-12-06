<H1 class="changer"><a href="index.jsp">C&J's Tasty Hats</a></H1>      
<hr>

<style>
    @keyframes colorChange {
        0% { color: #3399FF; }
        33% { color: #FF33CC; }
        66% { color: #33FF99; }
        100% { color: #3399FF; }
    }
    @keyframes wiggle {
        25% { transform: rotate(3deg); }
        75% { transform: rotate(-3deg); }
    }
    .changer {
        text-align: center;
        font-family: cursive;
        font-size: 50px;
        animation: colorChange 50s infinite, wiggle 10s infinite ease-in-out;
    }
    .changer a {
        text-decoration: none;
        color: inherit;
    }
</style>