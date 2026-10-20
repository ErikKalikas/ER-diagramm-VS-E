<%@ Page Title="Puudumised" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact3.aspx.vb" Inherits="ER_diagramm_VS_E.Contact3" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h3>Lapsed</h3>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
        DataKeyNames="laps_id" DataSourceID="SqlDataSourceLaps"
        OnSelectedIndexChanged="GridView1_SelectedIndexChanged" CssClass="table">
        <Columns>
            <asp:CommandField ShowSelectButton="True" SelectText="Vali" />
            <asp:BoundField DataField="eesnimi" HeaderText="Eesnimi" />
            <asp:BoundField DataField="perenimi" HeaderText="Perenimi" />
            <asp:BoundField DataField="isikukood" HeaderText="Isikukood" />
            <asp:BoundField DataField="synniaeg" HeaderText="Sünniaeg" DataFormatString="{0:dd.MM.yyyy}" />
        </Columns>
        <SelectedRowStyle BackColor="#cfe2ff" />
    </asp:GridView>

    <asp:SqlDataSource ID="SqlDataSourceLaps" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        SelectCommand="SELECT laps_id, eesnimi, perenimi, isikukood, synniaeg FROM Laps ORDER BY perenimi"></asp:SqlDataSource>

    <h3>Valitud lapse puudumised</h3>
    <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False"
        DataKeyNames="puudumine_id" DataSourceID="SqlDataSourcePuudumine"
        EmptyDataText="Puudumisi pole (või last pole valitud)." CssClass="table">
        <Columns>
            <asp:CommandField ShowDeleteButton="True" DeleteText="Kustuta" />
            <asp:BoundField DataField="alguse_kp" HeaderText="Algus" DataFormatString="{0:dd.MM.yyyy}" />
            <asp:BoundField DataField="lopu_kp" HeaderText="Lõpp" DataFormatString="{0:dd.MM.yyyy}" />
            <asp:BoundField DataField="pohjus" HeaderText="Põhjus" />
        </Columns>
    </asp:GridView>

    <asp:SqlDataSource ID="SqlDataSourcePuudumine" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        SelectCommand="SELECT puudumine_id, alguse_kp, lopu_kp, pohjus FROM Puudumine WHERE laps_id = @laps_id ORDER BY alguse_kp"
        DeleteCommand="DELETE FROM Puudumine WHERE puudumine_id = @puudumine_id">
        <SelectParameters>
            <asp:ControlParameter Name="laps_id" ControlID="GridView1" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="puudumine_id" Type="Int32" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False"
        DefaultMode="Insert" DataSourceID="SqlDataSourceLisa" Visible="False"
        OnItemInserted="DetailsView1_ItemInserted" HeaderText="Lisa puudumine" CssClass="table">
        <Fields>
            <asp:BoundField DataField="alguse_kp" HeaderText="Algus (pp.kk.aaaa)" />
            <asp:BoundField DataField="lopu_kp" HeaderText="Lõpp (pp.kk.aaaa)" />
            <asp:TemplateField HeaderText="Põhjus">
                <InsertItemTemplate>
                    <asp:DropDownList ID="ddlPohjus" runat="server" SelectedValue='<%# Bind("pohjus") %>'>
                        <asp:ListItem Value="haigus">haigus</asp:ListItem>
                        <asp:ListItem Value="puhkus">puhkus</asp:ListItem>
                        <asp:ListItem Value="muu">muu</asp:ListItem>
                    </asp:DropDownList>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ShowInsertButton="True" InsertText="Lisa" ShowCancelButton="False" />
        </Fields>
    </asp:DetailsView>

    <asp:SqlDataSource ID="SqlDataSourceLisa" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        InsertCommand="INSERT INTO Puudumine (laps_id, alguse_kp, lopu_kp, pohjus) VALUES (@laps_id, @alguse_kp, @lopu_kp, @pohjus)">
        <InsertParameters>
            <asp:ControlParameter Name="laps_id" ControlID="GridView1" PropertyName="SelectedValue" Type="Int32" />
            <asp:Parameter Name="alguse_kp" Type="DateTime" />
            <asp:Parameter Name="lopu_kp" Type="DateTime" />
            <asp:Parameter Name="pohjus" Type="String" />
        </InsertParameters>
    </asp:SqlDataSource>

</asp:Content>
