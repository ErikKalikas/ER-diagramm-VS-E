<%@ Page Title="Töötajate ametikohad" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact2.aspx.vb" Inherits="ER_diagramm_VS_E.Contact2" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
        DataSourceID="SqlDataSource1" EmptyDataText="Andmed puuduvad." CssClass="table">
        <Columns>
            <asp:BoundField DataField="eesnimi" HeaderText="Eesnimi" SortExpression="eesnimi" />
            <asp:BoundField DataField="perenimi" HeaderText="Perenimi" SortExpression="perenimi" />
            <asp:BoundField DataField="amet" HeaderText="Ametikoht" SortExpression="amet" />
            <asp:BoundField DataField="ruhm" HeaderText="Rühm" SortExpression="ruhm" NullDisplayText="köök" />
            <asp:BoundField DataField="alguse_kp" HeaderText="Algus" SortExpression="alguse_kp" DataFormatString="{0:dd.MM.yyyy}" />
            <asp:BoundField DataField="lopu_kp" HeaderText="Lõpp" SortExpression="lopu_kp" DataFormatString="{0:dd.MM.yyyy}" NullDisplayText="töötab" />
        </Columns>
    </asp:GridView>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        SelectCommand="SELECT Tootaja.eesnimi, Tootaja.perenimi, Ametikoha_tyyp.nimetus AS amet, Ruhm.nimetus AS ruhm, Tootamine.alguse_kp, Tootamine.lopu_kp FROM Tootamine INNER JOIN Tootaja ON Tootamine.tootaja_id = Tootaja.tootaja_id INNER JOIN Ametikoht ON Tootamine.ametikoht_id = Ametikoht.ametikoht_id INNER JOIN Ametikoha_tyyp ON Ametikoht.ametikoha_tyyp_id = Ametikoha_tyyp.ametikoha_tyyp_id LEFT JOIN Ruhm ON Ametikoht.ruhm_id = Ruhm.ruhm_id ORDER BY Tootaja.perenimi">
    </asp:SqlDataSource>
</asp:Content>
