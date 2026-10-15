<%@ Page Title="About" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.vb" Inherits="ER_diagramm_VS_E.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title">
        <h2 id="title"><%: Title %>.</h2>
        <p>
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="tootaja_id" DataSourceID="SqlDataSource1" EmptyDataText="There are no data records to display.">
                <Columns>
                    <asp:BoundField DataField="tootaja_id" HeaderText="tootaja_id" InsertVisible="False" ReadOnly="True" SortExpression="tootaja_id" />
                    <asp:BoundField DataField="eesnimi" HeaderText="eesnimi" SortExpression="eesnimi" />
                    <asp:BoundField DataField="perenimi" HeaderText="perenimi" SortExpression="perenimi" />
                    <asp:BoundField DataField="isikukood" HeaderText="isikukood" SortExpression="isikukood" />
                    <asp:BoundField DataField="telefon" HeaderText="telefon" SortExpression="telefon" />
                    <asp:BoundField DataField="e_post" HeaderText="e_post" SortExpression="e_post" />
                </Columns>
            </asp:GridView>
            <asp:EntityDataSource ID="EntityDataSource1" runat="server">
            </asp:EntityDataSource>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:LasteaedEConnectionString1 %>" DeleteCommand="DELETE FROM [TootajaSet] WHERE [tootaja_id] = @tootaja_id" InsertCommand="INSERT INTO [TootajaSet] ([eesnimi], [perenimi], [isikukood], [telefon], [e_post]) VALUES (@eesnimi, @perenimi, @isikukood, @telefon, @e_post)" ProviderName="<%$ ConnectionStrings:LasteaedEConnectionString1.ProviderName %>" SelectCommand="SELECT [tootaja_id], [eesnimi], [perenimi], [isikukood], [telefon], [e_post] FROM [TootajaSet]" UpdateCommand="UPDATE [TootajaSet] SET [eesnimi] = @eesnimi, [perenimi] = @perenimi, [isikukood] = @isikukood, [telefon] = @telefon, [e_post] = @e_post WHERE [tootaja_id] = @tootaja_id">
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
    </p>
    </main>
</asp:Content>
