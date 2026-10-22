<%@ Page Title="Lapsed" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact2.aspx.vb" Inherits="ER_diagramm_VS_E.Contact2" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
        DataSourceID="SqlDataSource1" EmptyDataText="Andmed puuduvad." CssClass="table">
        <Columns>
            <asp:BoundField DataField="laps_id" HeaderText="ID" SortExpression="laps_id" />
            <asp:BoundField DataField="eesnimi" HeaderText="Eesnimi" SortExpression="eesnimi" />
            <asp:BoundField DataField="perenimi" HeaderText="Perenimi" SortExpression="perenimi" />
            <asp:BoundField DataField="isikukood" HeaderText="Isikukood" SortExpression="isikukood" />
            <asp:BoundField DataField="synniaeg" HeaderText="Sünniaeg" SortExpression="synniaeg" DataFormatString="{0:dd.MM.yyyy}" />
            <asp:BoundField DataField="vanus" HeaderText="Vanus" SortExpression="vanus" />
            <asp:BoundField DataField="ruhm" HeaderText="Praegune rühm" SortExpression="ruhm" NullDisplayText="pole rühmas" />
            <asp:BoundField DataField="soovitud_ruhm" HeaderText="Soovitud rühm" SortExpression="soovitud_ruhm" NullDisplayText="—" />
            <asp:BoundField DataField="jarjekord" HeaderText="Järjekord" SortExpression="jarjekord" NullDisplayText="—" />
            <asp:BoundField DataField="puudumisi" HeaderText="Puudumisi" SortExpression="puudumisi" />
        </Columns>
    </asp:GridView>

    <%-- Praegune rühm: Ruhmas_olek, kus tänane kuupäev on alguse ja lõpu vahel (kui sellist pole: "pole rühmas").
         Järjekord ja soovitud rühm: viimane kirje tabelist Jarjekord. --%>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        SelectCommand="SELECT Laps.laps_id, Laps.eesnimi, Laps.perenimi, Laps.isikukood, Laps.synniaeg, (CONVERT(int, CONVERT(char(8), GETDATE(), 112)) - CONVERT(int, CONVERT(char(8), Laps.synniaeg, 112))) / 10000 AS vanus, praegu.nimetus AS ruhm, jk.staatus AS jarjekord, jk.soovitud_ruhm, (SELECT COUNT(*) FROM Puudumine WHERE Puudumine.laps_id = Laps.laps_id) AS puudumisi FROM Laps OUTER APPLY (SELECT TOP 1 Ruhm.nimetus FROM Ruhmas_olek INNER JOIN Ruhm ON Ruhmas_olek.ruhm_id = Ruhm.ruhm_id WHERE Ruhmas_olek.laps_id = Laps.laps_id AND CAST(GETDATE() AS date) BETWEEN Ruhmas_olek.alguse_kp AND ISNULL(Ruhmas_olek.lopu_kp, '9999-12-31') ORDER BY Ruhmas_olek.alguse_kp DESC) AS praegu OUTER APPLY (SELECT TOP 1 Jarjekord.staatus, Ruhm.nimetus AS soovitud_ruhm FROM Jarjekord LEFT JOIN Ruhm ON Jarjekord.soovitud_ruhm_id = Ruhm.ruhm_id WHERE Jarjekord.laps_id = Laps.laps_id ORDER BY Jarjekord.lisamise_kp DESC, Jarjekord.jarjekord_id DESC) AS jk ORDER BY Laps.perenimi, Laps.eesnimi">
    </asp:SqlDataSource>
</asp:Content>
