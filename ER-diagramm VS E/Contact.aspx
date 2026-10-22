<%@ Page Title="Töötajad" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.vb" Inherits="ER_diagramm_VS_E.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
        DataSourceID="SqlDataSource1" EmptyDataText="Andmed puuduvad." CssClass="table">
        <Columns>
            <asp:BoundField DataField="tootaja_id" HeaderText="ID" SortExpression="tootaja_id" />
            <asp:BoundField DataField="eesnimi" HeaderText="Eesnimi" SortExpression="eesnimi" />
            <asp:BoundField DataField="perenimi" HeaderText="Perenimi" SortExpression="perenimi" />
            <asp:BoundField DataField="isikukood" HeaderText="Isikukood" SortExpression="isikukood" />
            <asp:BoundField DataField="telefon" HeaderText="Telefon" SortExpression="telefon" />
            <asp:BoundField DataField="e_post" HeaderText="E-post" SortExpression="e_post" />
            <asp:BoundField DataField="amet" HeaderText="Ametikoht" SortExpression="amet" NullDisplayText="—" />
            <asp:BoundField DataField="ruhm" HeaderText="Rühm" SortExpression="ruhm" NullDisplayText="—" />
            <asp:BoundField DataField="alguse_kp" HeaderText="Algus" SortExpression="alguse_kp" DataFormatString="{0:dd.MM.yyyy}" NullDisplayText="—" />
            <asp:BoundField DataField="lopp" HeaderText="Lõpp" SortExpression="lopp" NullDisplayText="—" />
        </Columns>
    </asp:GridView>

    <%-- LEFT JOIN: näidatakse ka töötajaid, kellel pole ametikohta --%>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        SelectCommand="SELECT Tootaja.tootaja_id, Tootaja.eesnimi, Tootaja.perenimi, Tootaja.isikukood, Tootaja.telefon, Tootaja.e_post, Ametikoha_tyyp.nimetus AS amet, CASE WHEN Ametikoht.on_kooki_koht = 1 THEN N'köök' ELSE Ruhm.nimetus END AS ruhm, Tootamine.alguse_kp, CASE WHEN Tootamine.tootamine_id IS NOT NULL AND Tootamine.lopu_kp IS NULL THEN N'töötab' ELSE CONVERT(nvarchar(10), Tootamine.lopu_kp, 104) END AS lopp FROM Tootaja LEFT JOIN Tootamine ON Tootamine.tootaja_id = Tootaja.tootaja_id LEFT JOIN Ametikoht ON Tootamine.ametikoht_id = Ametikoht.ametikoht_id LEFT JOIN Ametikoha_tyyp ON Ametikoht.ametikoha_tyyp_id = Ametikoha_tyyp.ametikoha_tyyp_id LEFT JOIN Ruhm ON Ametikoht.ruhm_id = Ruhm.ruhm_id ORDER BY Tootaja.perenimi, Tootaja.eesnimi">
    </asp:SqlDataSource>
</asp:Content>
