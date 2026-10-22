<%@ Page Title="Lapsed" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact2.aspx.vb" Inherits="ER_diagramm_VS_E.Contact2" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <p><asp:Label ID="LabelTeade" runat="server" EnableViewState="False"></asp:Label></p>

    <h3>Kõik lapsed</h3>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="laps_id"
        DataSourceID="SqlDataSource1" EmptyDataText="Andmed puuduvad." CssClass="table"
        OnRowUpdated="GridView1_RowUpdated" OnRowDeleted="GridView1_RowDeleted">
        <Columns>
            <asp:TemplateField ShowHeader="False">
                <ItemTemplate>
                    <asp:LinkButton ID="LinkButtonEdit" runat="server" CausesValidation="False" CommandName="Edit" Text="Muuda rühma"></asp:LinkButton>
                    <asp:LinkButton ID="LinkButtonDelete" runat="server" CausesValidation="False" CommandName="Delete" Text="Kustuta"
                        OnClientClick="return confirm('Kustutada see laps koos tema rühmade, järjekorra ja puudumistega?');"></asp:LinkButton>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:LinkButton ID="LinkButtonUpdate" runat="server" CausesValidation="True" CommandName="Update" Text="Salvesta"></asp:LinkButton>
                    <asp:LinkButton ID="LinkButtonCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Tühista"></asp:LinkButton>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="laps_id" HeaderText="ID" SortExpression="laps_id" ReadOnly="True" />
            <asp:BoundField DataField="eesnimi" HeaderText="Eesnimi" SortExpression="eesnimi" ReadOnly="True" />
            <asp:BoundField DataField="perenimi" HeaderText="Perenimi" SortExpression="perenimi" ReadOnly="True" />
            <asp:BoundField DataField="synniaeg" HeaderText="Sünniaeg" SortExpression="synniaeg" DataFormatString="{0:dd.MM.yyyy}" ReadOnly="True" />
            <asp:BoundField DataField="vanus" HeaderText="Vanus" SortExpression="vanus" ReadOnly="True" />
            <asp:TemplateField HeaderText="Praegune rühm" SortExpression="ruhm">
                <ItemTemplate>
                    <asp:Label ID="LabelRuhm" runat="server" Text='<%# Eval("ruhm") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <%-- Uus rühm kehtib alates tänasest --%>
                    <asp:DropDownList ID="DropDownListRuhmMuuda" runat="server" DataSourceID="SqlDataSource3_ruhm"
                        DataTextField="nimi" DataValueField="ruhm_id" AppendDataBoundItems="True"
                        SelectedValue='<%# Bind("ruhm_id") %>'>
                        <asp:ListItem Value="">(pole rühmas)</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource3_ruhm" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
                        SelectCommand="SELECT Ruhm.ruhm_id, Ruhm.nimetus + ' (' + CAST((SELECT COUNT(*) FROM Ruhmas_olek WHERE Ruhmas_olek.ruhm_id = Ruhm.ruhm_id AND CAST(GETDATE() AS date) BETWEEN Ruhmas_olek.alguse_kp AND ISNULL(Ruhmas_olek.lopu_kp, '9999-12-31')) AS varchar(10)) + '/' + CAST(Ruhm.kohtade_arv AS varchar(10)) + ')' AS nimi FROM Ruhm ORDER BY Ruhm.nimetus"></asp:SqlDataSource>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="soovitud_ruhm" HeaderText="Soovitud rühm" SortExpression="soovitud_ruhm" NullDisplayText="—" ReadOnly="True" />
            <asp:BoundField DataField="jarjekord" HeaderText="Järjekord" SortExpression="jarjekord" NullDisplayText="—" ReadOnly="True" />
            <asp:BoundField DataField="puudumisi" HeaderText="Puudumisi" SortExpression="puudumisi" ReadOnly="True" />
        </Columns>
    </asp:GridView>

    <%-- Praegune rühm: Ruhmas_olek, kus tänane kuupäev on alguse ja lõpu vahel (kui sellist pole: "pole rühmas").
         Järjekord ja soovitud rühm: viimane kirje tabelist Jarjekord.
         Rühma muutmine (kui rühm tõesti muutus): praegune rühm lõpeb eile, tänased/tulevased rühma kirjed
         asendatakse, uus rühm algab täna; järjekorra kirje märgitakse "vastu võetud".
         Kustutamine: enne lapse kirjed tabelitest Puudumine, Jarjekord ja Ruhmas_olek (võõrvõtmed), siis laps. --%>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:LasteaedConnectionString2 %>"
        SelectCommand="SELECT Laps.laps_id, Laps.eesnimi, Laps.perenimi, Laps.synniaeg, (CONVERT(int, CONVERT(char(8), GETDATE(), 112)) - CONVERT(int, CONVERT(char(8), Laps.synniaeg, 112))) / 10000 AS vanus, praegu.ruhm_id, ISNULL(praegu.nimetus, N'pole rühmas') AS ruhm, jk.staatus AS jarjekord, jk.soovitud_ruhm, (SELECT COUNT(*) FROM Puudumine WHERE Puudumine.laps_id = Laps.laps_id) AS puudumisi FROM Laps OUTER APPLY (SELECT TOP 1 Ruhm.ruhm_id, Ruhm.nimetus FROM Ruhmas_olek INNER JOIN Ruhm ON Ruhmas_olek.ruhm_id = Ruhm.ruhm_id WHERE Ruhmas_olek.laps_id = Laps.laps_id AND CAST(GETDATE() AS date) BETWEEN Ruhmas_olek.alguse_kp AND ISNULL(Ruhmas_olek.lopu_kp, '9999-12-31') ORDER BY Ruhmas_olek.alguse_kp DESC) AS praegu OUTER APPLY (SELECT TOP 1 Jarjekord.staatus, Ruhm.nimetus AS soovitud_ruhm FROM Jarjekord LEFT JOIN Ruhm ON Jarjekord.soovitud_ruhm_id = Ruhm.ruhm_id WHERE Jarjekord.laps_id = Laps.laps_id ORDER BY Jarjekord.lisamise_kp DESC, Jarjekord.jarjekord_id DESC) AS jk ORDER BY Laps.perenimi, Laps.eesnimi"
        UpdateCommand="SET XACT_ABORT ON;
            DECLARE @tana date = CAST(GETDATE() AS date), @eile date = DATEADD(day, -1, CAST(GETDATE() AS date)), @praegu int;
            SELECT TOP 1 @praegu = [ruhm_id] FROM [Ruhmas_olek]
                WHERE [laps_id] = @laps_id AND @tana BETWEEN [alguse_kp] AND ISNULL([lopu_kp], '9999-12-31')
                ORDER BY [alguse_kp] DESC;
            IF ISNULL(@praegu, 0) != ISNULL(@ruhm_id, 0)
            BEGIN
            BEGIN TRY BEGIN TRAN;
                UPDATE [Ruhmas_olek] SET [lopu_kp] = @eile
                    WHERE [laps_id] = @laps_id AND [alguse_kp] BETWEEN '1900-01-01' AND @eile
                      AND ISNULL([lopu_kp], '9999-12-31') BETWEEN @tana AND '9999-12-31';
                DELETE FROM [Ruhmas_olek] WHERE [laps_id] = @laps_id AND [alguse_kp] BETWEEN @tana AND '9999-12-31';
                IF @ruhm_id IS NOT NULL
                BEGIN
                    INSERT INTO [Ruhmas_olek] ([laps_id], [ruhm_id], [alguse_kp]) VALUES (@laps_id, @ruhm_id, @tana);
                    UPDATE [Jarjekord] SET [staatus] = N'vastu võetud'
                        WHERE [laps_id] = @laps_id AND [staatus] IN (N'ootel', N'pakutud');
                END
            COMMIT TRAN; END TRY
            BEGIN CATCH IF @@TRANCOUNT != 0 ROLLBACK TRAN; THROW; END CATCH;
            END"
        DeleteCommand="SET XACT_ABORT ON;
            BEGIN TRY BEGIN TRAN;
            DELETE FROM [Puudumine] WHERE [laps_id] = @laps_id;
            DELETE FROM [Jarjekord] WHERE [laps_id] = @laps_id;
            DELETE FROM [Ruhmas_olek] WHERE [laps_id] = @laps_id;
            DELETE FROM [Laps] WHERE [laps_id] = @laps_id;
            COMMIT TRAN; END TRY
            BEGIN CATCH IF @@TRANCOUNT != 0 ROLLBACK TRAN; THROW; END CATCH;">
        <UpdateParameters>
            <asp:Parameter Name="ruhm_id" Type="Int32" />
            <asp:Parameter Name="laps_id" Type="Int32" />
        </UpdateParameters>
        <DeleteParameters>
            <asp:Parameter Name="laps_id" Type="Int32" />
        </DeleteParameters>
    </asp:SqlDataSource>
</asp:Content>
