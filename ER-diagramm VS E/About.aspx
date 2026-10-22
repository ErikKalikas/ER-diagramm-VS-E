<%@ Page Title="Lisa töötaja veebivorm" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.vb" Inherits="ER_diagramm_VS_E.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataKeyNames="tootaja_id"
        DataSourceID="SqlDataSource1" DefaultMode="Insert" Height="50px" Width="400px"
        OnItemInserted="DetailsView1_ItemInserted">
        <Fields>
            <asp:BoundField DataField="tootaja_id" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="tootaja_id" />
            <asp:BoundField DataField="eesnimi" HeaderText="Eesnimi" SortExpression="eesnimi" />
            <asp:BoundField DataField="perenimi" HeaderText="Perenimi" SortExpression="perenimi" />
            <asp:BoundField DataField="isikukood" HeaderText="Isikukood" SortExpression="isikukood" />
            <asp:BoundField DataField="telefon" HeaderText="Telefon" SortExpression="telefon" />
            <asp:BoundField DataField="e_post" HeaderText="E-post" SortExpression="e_post" />
            <asp:CommandField ShowInsertButton="True" InsertText="Lisa" CancelText="Tühista" NewText="Uus" />
        </Fields>
    </asp:DetailsView>

    <p><asp:Label ID="LabelTeade" runat="server" EnableViewState="False"></asp:Label></p>

    <h3>Töötajad</h3>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="tootaja_id"
        DataSourceID="SqlDataSource1" EmptyDataText="Andmed puuduvad." CssClass="table"
        OnRowUpdated="GridView1_RowUpdated" OnRowDeleted="GridView1_RowDeleted">
        <Columns>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" EditText="Muuda" DeleteText="Kustuta" UpdateText="Salvesta" CancelText="Tühista" />
            <asp:BoundField DataField="tootaja_id" HeaderText="ID" ReadOnly="True" SortExpression="tootaja_id" />
            <asp:BoundField DataField="eesnimi" HeaderText="Eesnimi" SortExpression="eesnimi" />
            <asp:BoundField DataField="perenimi" HeaderText="Perenimi" SortExpression="perenimi" />
            <asp:BoundField DataField="isikukood" HeaderText="Isikukood" SortExpression="isikukood" />
            <asp:BoundField DataField="telefon" HeaderText="Telefon" SortExpression="telefon" />
            <asp:BoundField DataField="e_post" HeaderText="E-post" SortExpression="e_post" />
        </Columns>
    </asp:GridView>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        ProviderName="<%$ ConnectionStrings:LasteaedConnectionString2.ProviderName %>"
        SelectCommand="SELECT [tootaja_id], [eesnimi], [perenimi], [isikukood], [telefon], [e_post] FROM [Tootaja]"
        InsertCommand="INSERT INTO [Tootaja] ([eesnimi], [perenimi], [isikukood], [telefon], [e_post]) VALUES (@eesnimi, @perenimi, @isikukood, @telefon, @e_post)"
        UpdateCommand="UPDATE [Tootaja] SET [eesnimi] = @eesnimi, [perenimi] = @perenimi, [isikukood] = @isikukood, [telefon] = @telefon, [e_post] = @e_post WHERE [tootaja_id] = @tootaja_id"
        DeleteCommand="DELETE FROM [Tootaja] WHERE [tootaja_id] = @tootaja_id">
        <DeleteParameters>
            <asp:Parameter Name="tootaja_id" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="eesnimi" Type="String" />
            <asp:Parameter Name="perenimi" Type="String" />
            <asp:Parameter Name="isikukood" Type="String" />
            <asp:Parameter Name="telefon" Type="String" />
            <asp:Parameter Name="e_post" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="eesnimi" Type="String" />
            <asp:Parameter Name="perenimi" Type="String" />
            <asp:Parameter Name="isikukood" Type="String" />
            <asp:Parameter Name="telefon" Type="String" />
            <asp:Parameter Name="e_post" Type="String" />
            <asp:Parameter Name="tootaja_id" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>
