<%@ Page Title="Contact" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact2.aspx.vb" Inherits="ER_diagramm_VS_E.Contact2" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <p>
        tabel<br />
        <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AutoGenerateColumns="False" DataSourceID="SqlDataSource2">
            <Columns>
                <asp:CommandField ShowSelectButton="True" />
                <asp:BoundField DataField="nimetus" HeaderText="nimetus" SortExpression="nimetus" />
                <asp:BoundField DataField="eesnimi" HeaderText="eesnimi" SortExpression="eesnimi" />
                <asp:BoundField DataField="kohtade_arv" HeaderText="kohtade_arv" SortExpression="kohtade_arv" />
                <asp:BoundField DataField="perenimi" HeaderText="perenimi" SortExpression="perenimi" />
                <asp:BoundField DataField="isikukood" HeaderText="isikukood" SortExpression="isikukood" />
                <asp:BoundField DataField="synniaeg" HeaderText="synniaeg" SortExpression="synniaeg" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>" SelectCommand="SELECT Ruhm.nimetus, Laps.eesnimi, Ruhm.kohtade_arv, Laps.perenimi, Laps.isikukood, Laps.synniaeg FROM Laps INNER JOIN Jarjekord ON Laps.laps_id = Jarjekord.laps_id INNER JOIN Ruhm ON Jarjekord.soovitud_ruhm_id = Ruhm.ruhm_id"></asp:SqlDataSource>
    </p>
    <p>
    </p>
</asp:Content>
