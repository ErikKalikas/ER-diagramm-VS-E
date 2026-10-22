<%@ Page Title="Töötajad" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.vb" Inherits="ER_diagramm_VS_E.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
        DataSourceID="SqlDataSource1" EmptyDataText="Andmed puuduvad." CssClass="table">
        <Columns>
            <asp:BoundField DataField="tootaja_id" HeaderText="tootaja_id" SortExpression="tootaja_id" />
            <asp:BoundField DataField="eesnimi" HeaderText="Eesnimi" SortExpression="eesnimi" />
            <asp:BoundField DataField="perenimi" HeaderText="Perenimi" SortExpression="perenimi" />
            <asp:BoundField DataField="isikukood" HeaderText="Isikukood" SortExpression="isikukood" />
            <asp:BoundField DataField="telefon" HeaderText="Telefon" SortExpression="telefon" />
            <asp:BoundField DataField="e_post" HeaderText="E-post" SortExpression="e_post" />
        </Columns>
    </asp:GridView>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        SelectCommand="SELECT [tootaja_id], [eesnimi], [perenimi], [isikukood], [telefon], [e_post] FROM [Tootaja] ORDER BY [perenimi]">
    </asp:SqlDataSource>
</asp:Content>
